module ShiftRegister (
    input clk,
    input rst,
    input en,
    input data_in,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else if (en)
            q <= {data_in, q[7:1]};
    end

endmodule