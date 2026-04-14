module up_down_counter_2bit(
    input clk, 
    input reset, 
    input enable, 
    input up_down, 
    output reg [1:0] count);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 2'b00;
        else if (enable) begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule