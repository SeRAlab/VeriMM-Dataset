module top_module(
    input [3:0] data_in,
    input reset,
    output reg [3:0] data_out
    );always @ (data_in or reset) begin
        if (reset == 1) begin
            data_out <= 0;
        end
        else begin
            data_out <= ~data_in + 1;
        end
    end

endmodule