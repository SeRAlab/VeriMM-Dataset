module top_module(IN1, IN2, IN3, QN);input IN1;
    input IN2, IN3;
    output QN;

    wire nand1, nand2;

    // Instantiate NAND gates and NOT gate
    assign nand1 = ~(IN1 & IN2 & IN3); // NAND3 functionality
    assign nand2 = ~(nand1 & nand1);  // NAND2 functionality for double negation
    assign QN = ~nand2;                // NOT functionality

endmodule