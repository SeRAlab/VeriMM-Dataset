module top_module (
    input clk,
    input reset,
    output [1:0] gray_count );reg [1:0] binary_count;
    reg [1:0] gray_count_reg;
    
    always @(posedge clk) begin
        if (reset)
            binary_count <= 2'b00;
        else
            binary_count <= binary_count + 1;
    end
    
    always @(*) begin
        gray_count_reg = {binary_count[1], binary_count[1] ^ binary_count[0]};
    end
    
    assign gray_count = gray_count_reg;
    
endmodule