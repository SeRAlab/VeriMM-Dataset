module top_module(
    input load,
    input reset,
    input count_up,
    input count_down,
    input [3:0] data_in,
    output reg [3:0] count_out
);always @ (posedge count_up or posedge count_down or posedge reset or posedge load)
    begin
        if (reset) begin
            count_out <= 4'b0000;
        end
        else if (load) begin
            count_out <= data_in;
        end
        else if (count_up) begin
            count_out <= count_out + 1;
        end
        else if (count_down) begin
            count_out <= count_out - 1;
        end
    end

endmodule