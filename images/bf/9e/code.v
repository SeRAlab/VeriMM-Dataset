module top_module(
    input wire clk_in,
    output[1:0] count_out
    );reg[1:0] count = 0;  
    always @(posedge clk_in)
        begin
        count <= (count == 2)? 0: count + 1; 
        end
    assign count_out = count; 
endmodule