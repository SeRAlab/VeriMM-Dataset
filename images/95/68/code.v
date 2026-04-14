module top_module(clk, reset, load, data_in, data_out);input clk, reset, load;
    input [15:0] data_in;
    output [15:0] data_out;

    reg [15:0] reg_data;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            reg_data <= 16'h0;
        end else if (load) begin
            reg_data <= data_in;
        end
    end

    assign data_out = reg_data;

endmodule