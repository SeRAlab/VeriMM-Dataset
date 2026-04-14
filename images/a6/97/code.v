module verified_binary_counter(
    input clk,
    input rst,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0000;
        else
            count <= (count == 4'b1111) ? 4'b0000 : count + 1;
    end

endmodule