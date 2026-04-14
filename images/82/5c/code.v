module top_module(
    input clk,            // Added clk input
    input [15:0] in,
    output reg [3:0] count
);reg [15:0] in_reg;
integer i;

always @(posedge clk) begin
    in_reg <= in;
end

always @(*) begin
    count = 0;
    for(i=0; i<16; i=i+1) begin
        if(in_reg[i] == 1'b1) begin
            count = count + 1;
        end
    end
end

endmodule