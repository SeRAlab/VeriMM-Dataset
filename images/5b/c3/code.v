module shift_register(
    input                 clk,
    input                 rst_n,
    input                 load,
    input                 shift,
    input                 shift_dir,
    input       [7:0]     data_in,
    output   reg [7:0]    data_out
);

// Shift register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 8'd0;
    end else if (load) begin
        data_out <= data_in;
    end else if (shift) begin
        if (shift_dir == 1'b0) begin
            data_out <= data_out << 1;
        end else begin
            data_out <= data_out >> 1;
        end
    end
end

endmodule