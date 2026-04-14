module top_module(
    input clk,
    input rst,
    input shift_dir,
    input load,
    input [3:0] data_in,
    input enable,
    output [3:0] data_out,
    output empty,
    output full
);reg [3:0] reg_data;

always @(posedge clk) begin
    if (rst) begin
        reg_data <= 4'b0;
    end else if (load) begin
        reg_data <= data_in;
    end else if (enable) begin
        if (shift_dir) begin
            reg_data <= {reg_data[2:0], 1'b0};
        end else begin
            reg_data <= {1'b0, reg_data[3:1]};
        end
    end
end

assign data_out = reg_data;

assign empty = (reg_data == 4'b0);
assign full = (reg_data == 4'b1111);

endmodule