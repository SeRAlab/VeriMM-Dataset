module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [3:0] parallel_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 4'b0;
        end else begin
            parallel_out <= {parallel_out[2:0], serial_in};
        end
    end

endmodule