module top_module(
    input [7:0] a,
    input [7:0] b,
    input [2:0] op,
    input sel,
    output reg [7:0] out   // Change output to reg type
);reg [7:0] result;

always @(*) begin
    case(op)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = ~a;
        3'b110: result = a << b;
        3'b111: result = a >> b;
        default: result = 8'h00;
    endcase
    
    if(sel) begin
        out = result;   // Now valid since out is reg
    end else begin
        out = a;        // Now valid since out is reg
    end
end

endmodule