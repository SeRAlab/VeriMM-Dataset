module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg edge_detected
);
    reg signal_in_prev;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            edge_detected <= 0;
            signal_in_prev <= 0;
        end else begin
            edge_detected <= (signal_in & ~signal_in_prev);
            signal_in_prev <= signal_in;
        end
    end
endmodule