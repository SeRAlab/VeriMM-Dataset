module up_down_counter(
    input clk,
    input reset_n,
    input enable,
    input up_down,
    output reg [3:0] count
    );
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 4'b0000;
        else if (enable) begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule