module siso_shift_register (
    input clk,
    input en,
    input serial_in,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (en) begin
            q <= {serial_in, q[3:1]};
        end
    end
endmodule