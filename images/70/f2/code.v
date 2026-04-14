module top_module(
    input clk,
    input [2:0] readnum,
    input vsel,
    input loada,
    input loadb,
    input [1:0] shift,
    input asel,
    input bsel,
    input [1:0] ALUop,
    input loadc,
    input loads,
    input [2:0] writenum,
    input write,
    input [15:0] datapath_in,
    output reg [15:0] datapath_out,
    output reg status
);reg [15:0] regfile [0:7]; // Changed to 8 registers, 3:0 to 0:7 for 8 register space
reg [15:0] A, B, C; // 16-bit inputs to the ALU
reg [3:0] shift_amt; // amount to shift B by
reg [15:0] ALUout; // output of the ALU
reg carry_out, overflow; // flags for the status register

always @(posedge clk) begin
    // read from register
    if (loada) A <= regfile[readnum];
    if (loadb) B <= regfile[readnum];

    // set the shift amount based on shift input
    case (shift)
        2'b00: shift_amt <= 1;
        2'b01: shift_amt <= 4;
        2'b10: shift_amt <= 8;
        2'b11: shift_amt <= 16;
    endcase

    // shift B based on the shift amount
    B <= (shift == 2'b00) ? {B[14:0], 1'b0} : // Logical left shift 1 bit
         (shift == 2'b01) ? {B[11:0], 4'b0} : // Logical left shift 4 bits
         (shift == 2'b10) ? {B[7:0], 8'b0} : // Logical left shift 8 bits
         (shift == 2'b11) ? 16'b0 : B;         // Logical left shift 16 bits or reset B

    // perform ALU operation
    case (ALUop)
        2'b00: ALUout <= A + B;
        2'b01: ALUout <= A - B;
        2'b10: ALUout <= A & B;
        2'b11: ALUout <= A | B;
    endcase
    carry_out <= ALUout[15]; // Updated to use correct bit for carry
    overflow <= (A[15] == B[15]) && (ALUout[15] != A[15]);

    // load output into C
    if (loadc) C <= ALUout;

    // write to register
    if (write && vsel) regfile[writenum] <= datapath_in;

    // set output
    if (asel) datapath_out <= A;
    else if (bsel) datapath_out <= B;
    else datapath_out <= ALUout;

    // set status register
    if (loads) status <= carry_out || overflow;
end

endmodule