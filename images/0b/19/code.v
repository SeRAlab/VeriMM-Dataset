module sr_flip_flop (
    input wire S,       // Set input
    input wire R,       // Reset input
    input wire clk,     // Clock input
    input wire rst,     // Asynchronous reset
    output reg Q,       // Output Q
    output reg Q_not    // Output Q_not
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Q <= 0;
        Q_not <= 1;
    end else begin
        if (S && ~R) begin
            Q <= 1;
            Q_not <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Q_not <= 1;
        end else if (S && R) begin
            // Invalid state, hold previous value
        end
    end
end

endmodule