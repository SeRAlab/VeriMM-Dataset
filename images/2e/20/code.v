module noise_suppression(
    input clk,
    input rst,
    input signal_in,
    output reg signal_out
);
    reg [1:0] stable_count; // Count the number of stable cycles
    reg last_signal;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stable_count <= 0;
            signal_out <= 0;
            last_signal <= 0;
        end else begin
            if (signal_in == last_signal) begin
                stable_count <= stable_count + 1;
                if (stable_count >= 2) begin // stable for 3 cycles
                    signal_out <= signal_in;
                end
            end else begin
                stable_count <= 0; // reset count if the signal changes
            end
            last_signal <= signal_in;
        end
    end
endmodule