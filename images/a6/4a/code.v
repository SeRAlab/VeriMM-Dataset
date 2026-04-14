module top_module(
    input [3:0] data_in,
    input shift,
    input load,
    input clk,
    input reset,
    output [3:0] data_out
);reg [3:0] reg_data;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            reg_data <= 4'b0;
        end else if (load) begin
            reg_data <= data_in;
        end else if (shift) begin
            reg_data <= {reg_data[2:0], reg_data[3]}; // Shift left
        end else begin
            reg_data <= {reg_data[0], reg_data[3:1]}; // Shift right
        end
    end

    assign data_out = reg_data;

endmodule