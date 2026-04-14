module edge_detector(
    input wire clk,
    input wire rst,
    input wire en,
    input wire signal_in,
    output reg pulse_out
);

reg signal_in_d;

always @(posedge clk) begin
    if (rst) begin
        signal_in_d <= 1'b0;
        pulse_out <= 1'b0;
    end else if (en) begin
        signal_in_d <= signal_in;
        pulse_out <= signal_in && !signal_in_d;
    end else begin
        pulse_out <= 1'b0;
    end
end

endmodule