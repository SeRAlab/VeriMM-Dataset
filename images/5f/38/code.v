module top_module(
    input [7:0] data_in,
    input enable,
    output reg [7:0] data_out
);always @ (enable, data_in) begin
        if (enable == 1'b0) begin
            data_out <= 8'h00;
        end
        else begin
            data_out <= {data_in, 2'b00};
        end
    end

endmodule