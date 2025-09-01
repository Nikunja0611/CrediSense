// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract LoanManager {
    enum Status { Pending, Approved, Rejected, Waitlisted }

    struct Loan {
        uint id;
        address applicant;
        uint amount;
        Status status;
        bool agreed; // ✅ user must agree to terms
    }

    address public admin;
    uint public loanCount;
    mapping(uint => Loan) public loans;

    event LoanApplied(uint loanId, address applicant, uint amount, bool agreed);
    event LoanUpdated(uint loanId, Status status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // ✅ User must pass agreed = true or tx will revert
    function applyForLoan(uint amount, bool agreed) external {
        require(amount > 0, "Amount must be > 0");
        require(agreed, "You must agree to terms before applying");

        loanCount++;
        loans[loanCount] = Loan(loanCount, msg.sender, amount, Status.Pending, agreed);

        emit LoanApplied(loanCount, msg.sender, amount, agreed);
    }

    function approveLoan(uint loanId) external onlyAdmin {
        require(loans[loanId].id != 0, "Loan does not exist");
        loans[loanId].status = Status.Approved;
        emit LoanUpdated(loanId, Status.Approved);
    }

    function rejectLoan(uint loanId) external onlyAdmin {
        require(loans[loanId].id != 0, "Loan does not exist");
        loans[loanId].status = Status.Rejected;
        emit LoanUpdated(loanId, Status.Rejected);
    }

    function waitlistLoan(uint loanId) external onlyAdmin {
        require(loans[loanId].id != 0, "Loan does not exist");
        loans[loanId].status = Status.Waitlisted;
        emit LoanUpdated(loanId, Status.Waitlisted);
    }

    function getLoan(uint loanId) external view returns (Loan memory) {
        require(loans[loanId].id != 0, "Loan does not exist");
        return loans[loanId];
    }
}
