module ShiftRegister (
    input clk,
    input rst_n,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'b00000000;
        else if (load)
            q <= data_in;
        else
            q <= {1'b0, q[7:1]};
    end
endmodule