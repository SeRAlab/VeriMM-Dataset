module shift_reg_16bit (
    input clk,
    input rst_n,
    input load_en,
    input shift_en,
    input shift_dir,
    input [15:0] parallel_in,
    output reg serial_out,
    output reg [15:0] parallel_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        parallel_out <= 16'b0;
    else if (load_en)
        parallel_out <= parallel_in;
    else if (shift_en) begin
        if (shift_dir) begin
            serial_out <= parallel_out[0];
            parallel_out <= {1'b0, parallel_out[15:1]};
        end else begin
            serial_out <= parallel_out[15];
            parallel_out <= {parallel_out[14:0], 1'b0};
        end
    end
end

endmodule