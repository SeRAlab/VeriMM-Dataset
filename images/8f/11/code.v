module top_module(
    input clk,
    input [3:0] data_in,
    input shift_en,
    input load_en,
    output [3:0] data_out
);reg [3:0] reg_data;

always @(posedge clk) begin
    if (load_en) begin
        reg_data <= data_in;
    end else if (shift_en) begin
        reg_data <= {reg_data[2:0], reg_data[3]};
    end
end

assign data_out = reg_data;

endmodule