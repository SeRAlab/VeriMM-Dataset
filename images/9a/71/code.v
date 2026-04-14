module shift_register(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    input shift_in,
    output reg shift_out,
    output reg [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'd0;
        end else if (load) begin
            q <= data_in;
        end else begin
            q <= {q[6:0], shift_in};
            shift_out <= q[7];
        end
    end
endmodule