module top_module(
    input wire [7:0] a, b,
    input wire [2:0] alu_sel,
    output reg [7:0] res,
    output reg [3:0] nzvc
    );always@(a, b, alu_sel)
begin
    
    case(alu_sel)
        3'b00:
        begin
            res = a + b;
        end
    
    endcase
end

endmodule