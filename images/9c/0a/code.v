module shift_register(
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] parallel_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            parallel_out <= 8'b00000000;
        else
            parallel_out <= {parallel_out[6:0], serial_in};
    end
endmodule