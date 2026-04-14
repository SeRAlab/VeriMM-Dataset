module top_module(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    input [3:0] in,
    input select,
    output reg [5:0] out
);// Priority Encoder Logic
wire [1:0] priority_out;
reg [3:0] alu_out;

// Priority Encoder - Implementing a basic 4-to-2 priority encoder
assign priority_out[1] = (A[3] || B[3]) ? 2'b11 :
                          (A[2] || B[2]) ? 2'b10 :
                          (A[1] || B[1]) ? 2'b01 :
                          (A[0] || B[0]) ? 2'b00 :
                          2'b00;

// ALU Logic - Simple ALU operations based on opcode
always @(*) begin
    case (opcode)
        3'b000: alu_out = A + B;      // ADD
        3'b001: alu_out = A - B;      // SUB
        3'b010: alu_out = A & B;      // AND
        3'b011: alu_out = A | B;      // OR
        3'b100: alu_out = A ^ B;      // XOR
        3'b101: alu_out = ~A;         // NOT A
        3'b110: alu_out = A << 1;     // Shift Left
        3'b111: alu_out = A >> 1;     // Shift Right
        default: alu_out = 4'b0000;
    endcase
end

// Combining outputs based on select signal
always @(posedge clk) begin
    if (reset) begin
        out <= 6'b0;
    end else begin
        if (select == 0) begin
            out <= {priority_out, 2'b0};
        end else begin
            out <= {2'b0, alu_out};
        end
    end
end

endmodule