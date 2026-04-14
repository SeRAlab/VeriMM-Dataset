module top_module(input A, input B, input C, output Y);// Inputs are registered
    reg A_reg;
    reg B_reg;
    reg C_reg;

    // Output wire
    wire Y_nand;

    // Power and ground pins
    supply1 VDD;
    supply0 VSS;

    // NAND3 gate
    assign Y_nand = ~(A_reg & B_reg & C_reg);

    // Input registers
    always @(posedge VDD) begin
        A_reg <= A;
        B_reg <= B;
        C_reg <= C;
    end

    // Output assignment
    assign Y = Y_nand;

endmodule