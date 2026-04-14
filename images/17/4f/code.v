module fir_filter (
    input [3:0] x, // Input signal
    output [7:0] y // Output signal
);
    reg [7:0] y_temp; // Temporary output storage

    always @(*) begin
        // Coefficients for the 4-tap FIR filter
        y_temp = (x * 4'd1) + (({x[3], x[3:1]}) * 4'd2) + (({x[3], x[3:2]}) * 4'd3) + (({x[3:1], 1'b0}) * 4'd1);
    end

    assign y = y_temp;
endmodule