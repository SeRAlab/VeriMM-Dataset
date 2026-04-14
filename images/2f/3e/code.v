module shift_register (
    input clk,
    input reset,
    input [1:0] data_in,
    output reg [1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 2'b00;
        else
            q <= {data_in[0], q[1]};
    end
endmodule