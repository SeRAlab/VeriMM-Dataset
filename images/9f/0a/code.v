module up_counter_2bit(
    input clk, rst,
    output reg [1:0] count);

    always @(posedge clk) begin
        if (rst)
            count <= 2'b0;
        else
            count <= count + 1;
    end
endmodule