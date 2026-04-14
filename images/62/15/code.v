module shift_reg_16bit (
    input clk,
    input rst,
    input shift_en,
    input load_en,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 16'b0;
    end
    else if (load_en) begin
        data_out <= data_in;
    end
    else if (shift_en) begin
        data_out <= {1'b0, data_out[15:1]};
    end
end

endmodule