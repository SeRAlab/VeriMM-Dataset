module up_counter(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] count
    );
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            count <= 8'b00000000;
        else if (enable)
            count <= count + 1;
    end
endmodule