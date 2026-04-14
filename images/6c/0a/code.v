module top_module(
    input clk,
    input [4:0] R_Addr_A,
    input [4:0] R_Addr_B,
    input [4:0] W_Addr,
    input Reset,
    input Write_Reg,
    input [2:0] ALU_OP,
    output reg [31:0] LED, // Changed from wire to reg
    output [31:0] A,
    output [31:0] B,
    output OF,
    output ZF
);// Register file
    reg [31:0] regs [31:0];

    // Combinational logic for OF and ZF
    wire [32:0] result;
    assign result = {1'b0, A} + {1'b0, B};
    assign OF = (result[33] != result[32]);
    assign ZF = (result == 0);

    // Read A and B from register file
    assign A = regs[R_Addr_A];
    assign B = regs[R_Addr_B];

    // Perform operation based on ALU_OP
    always @(posedge clk) begin
        if (Reset) begin
            LED <= 0;
        end else begin
            case (ALU_OP)
                3'b000: LED <= A + B;
                3'b001: LED <= A - B;
                3'b010: LED <= A & B;
                3'b011: LED <= A | B;
                3'b100: LED <= A ^ B;
                3'b101: LED <= A << B;
                3'b110: LED <= A >> B;
                3'b111: LED <= $signed(A) >>> B;
            endcase
        end
    end

    // Write LED to register file if Write_Reg is high
    always @(posedge clk) begin
        if (Reset) begin
            regs[W_Addr] <= 0;
        end else if (Write_Reg) begin
            regs[W_Addr] <= LED;
        end
    end

endmodule