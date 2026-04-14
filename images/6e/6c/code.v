module top_module(
    input clk,
    input reset,           // Synchronous active-high reset for BCD counter
    input [3:0] in,        // Input for the priority encoder
    output reg [1:0] pos,  // Output of the priority encoder
    output reg [2:0] ena,   // Enable signals for the upper three digits of the BCD counter
    output reg zero_flag,  // Output flag indicating countdown has completed
    output reg [15:0] q    // Output of the BCD counter
);reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b1001;
        q <= 16'b1001100110011001;
        ena <= 3'b111;
        pos <= 2'b00;
        zero_flag <= 1'b0;
    end else begin
        if (count == 4'b0000) begin
            zero_flag <= 1'b1;
            ena <= 3'b000;
        end else begin
            zero_flag <= 1'b0;
            ena <= {3{pos == 2'b11}} & {2{pos != 2'b11}}; // Corrected the assignment for ena
            q <= {q[15:4], count};
            case (in)
                4'b1000: pos <= 2'b11;
                4'b0100: pos <= 2'b10;
                4'b0010: pos <= 2'b01;
                4'b0001: pos <= 2'b00;
                default: pos <= 2'b00;
            endcase
            if (ena[1]) count[3] <= ~|count[2:0];
            if (ena[2]) count[2] <= ~|count[1:0];
            if (ena[0]) count[1] <= ~|count[0]; // Fixed index for ena
            count[0] <= ~count[0];
        end
    end
end

endmodule