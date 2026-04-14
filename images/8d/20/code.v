module verified_up_down_counter(
    input clk,
    input rst,
    input up,
    output reg [1:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 2'b00;
        else if (up)
            count <= count + 1;
        else
            count <= count - 1;
    end

endmodule