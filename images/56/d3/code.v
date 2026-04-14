module top_module(
    input [3:0] data,
    input shift,
    output reg serial_out,
    output reg [3:0] q
);always @ (posedge shift) begin
        if (shift) begin
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3];
            q[3] <= data;
            serial_out <= q[0];
        end
        else begin
            q <= data;
            serial_out <= q[0];
        end
    end

endmodule