module sync_up_counter_with_load(
    input clk,
    input rst,
    input load,
    input [15:0] d,
    output reg [15:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0;
        end else if (load) begin
            q <= d;
        end else begin
            q <= q + 1;
        end
    end
endmodule