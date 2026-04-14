module top_module(
    input clk,
    input reset,
    input load,
    input shift,
    input serial_in,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
        end else if (load) begin
            q <= {q[6:0], serial_in};
        end else if (shift) begin
            q <= {serial_in, q[7:1]};
        end
    end

endmodule