module counter_16bit_up_down(
    input clk, reset, up, down,
    output reg [15:0] count);
    
    always @(posedge clk) begin
        if (reset)
            count <= 16'b0;
        else if (up)
            count <= count + 1;
        else if (down)
            count <= count - 1;
    end
endmodule