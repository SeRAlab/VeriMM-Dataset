module shift_register_16bit
(
    input clk,
    input rst_n,
    input shift_en,
    input shift_dir,
    input [15:0] data_in,
    input load,
    output reg [15:0] result
);

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        result <= 16'd0;
    end else if (load) begin
        result <= data_in;
    end else if (shift_en) begin
        if (shift_dir) begin
            result <= result << 1;
        end else begin
            result <= result >> 1;
        end
    end
end

endmodule