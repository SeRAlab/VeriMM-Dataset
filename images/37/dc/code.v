module chebyshev_filter(
    input clk,
    input rst,
    input [4:0] signal_in,
    output reg [4:0] signal_out
);
    reg [4:0] state[2:0]; // 3 states for the filter
    reg [1:0] count; // To count clock cycles

    // Filter coefficients
    parameter K0 = 5'b00001; // Example coefficient for a 3rd order filter
    parameter K1 = 5'b00001; // Example coefficient for a 3rd order filter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state[0] <= 5'b00000;
            state[1] <= 5'b00000;
            state[2] <= 5'b00000;
            signal_out <= 5'b00000;
            count <= 0;
        end else begin
            // State update based on the input signal and filter coefficients
            state[0] <= signal_in;
            state[1] <= state[0] * K0;
            state[2] <= state[1] + state[0] * K1;

            if (count < 2) begin
                count <= count + 1;
            end else begin
                signal_out <= state[2];
                count <= 0;
            end
        end
    end
endmodule