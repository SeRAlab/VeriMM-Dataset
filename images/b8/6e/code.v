module top_module(
    input clk,
    input data_available,
    input [7:0] data_in,
    input data_read,
    input reset,
    output reg [7:0] data_out,
    output reg data_out_en
    );reg [7:0] data_reg;

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            data_reg <= 8'b00000000;
        end 
        else if (data_available && !data_read) begin
            data_reg <= data_reg + 1;
        end
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            data_out <= 8'b00000000;
            data_out_en <= 1'b0;
        end 
        else if (data_available && !data_read) begin
            data_out <= data_reg;
            data_out_en <= 1'b1;
        end
        else if (data_read) begin
            data_out <= data_reg;
            data_out_en <= 1'b1;
        end
        else begin
            data_out_en <= 1'b0;
        end
    end
endmodule