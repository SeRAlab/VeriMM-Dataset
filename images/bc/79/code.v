module top_module(
    input clk,
    input [31:0] data_in,
    input valid_in,
    input ready_out,
    output [31:0] data_out,
    output valid_out
);reg [31:0] data_out_reg;
    reg valid_out_reg;
    reg transmit_data;

    always @(posedge clk) begin
        if (valid_in && ready_out) begin
            data_out_reg <= data_in;
            transmit_data <= 1;
        end else if (ready_out && transmit_data) begin
            data_out_reg <= 'hx;
            transmit_data <= 0;
            valid_out_reg <= 1;
        end else if (valid_out_reg) begin
            valid_out_reg <= 0;
        end
    end

    assign data_out = data_out_reg;
    assign valid_out = valid_out_reg;

endmodule