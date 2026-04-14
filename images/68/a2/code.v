module up_counter_4bit(
    input clk, 
    input rst, 
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst)
            count <= 4'd0;
        else
            count <= count + 1;
    end
endmodule