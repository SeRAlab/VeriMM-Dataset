module sync_up_counter_16bit(
    input clk,
    input rst,
    input load,
    input [15:0] data,
    output reg [15:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (load) begin
            q <= data;
        end else begin
            q <= q + 1;
        end
    end
endmodule