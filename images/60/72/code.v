module counter_8bit_down(
    input clk, reset,
    output reg [7:0] count);
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 8'b11111111;
        else
            count <= count - 1;
    end
endmodule