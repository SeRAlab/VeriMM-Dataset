module shift_reg_8bit(
    input clk,
    input rst,
    input load,
    input shift,
    input [7:0] parallel_in,
    input serial_in,
    output reg [7:0] parallel_out,
    output serial_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 8'b0;
        end else if (load) begin
            parallel_out <= parallel_in;
        end else if (shift) begin
            parallel_out <= {parallel_out[6:0], serial_in};
        end
    end

    assign serial_out = parallel_out[7];
endmodule