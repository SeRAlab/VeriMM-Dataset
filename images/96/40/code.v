module top_module(
    output reg [7:0] out,
    input wire [7:0] in_0,
    input wire [7:0] in_1,
    input select
);always @(*) begin 

    case(select) 
        1'b0: out = in_0;
        1'b1: out = in_1;
        default: out = in_0;
    endcase
end
    

endmodule