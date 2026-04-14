module top_module(
    input clk,
    input reset,           // Synchronous active-high reset
    input [31:0] in,       // 32-bit input for the transition detector module
    output reg [7:0] count // 8-bit output representing the count
);reg [7:0] counter; // 8-bit binary counter
    reg [31:0] prev_in; // Previous value of the input vector for transition detection

    // Instantiate the 8-bit flip-flop module
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;
        end else begin
            counter <= prev_in[7:0];
        end
    end

    // Instantiate the 32-bit transition detector module
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            if (in[31:1] > prev_in[30:0]) begin
                counter <= counter + 1;
            end
        end
    end

    assign count = counter;

endmodule