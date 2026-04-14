module top_module( 
    input clk, 
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    input select,     // Select input to choose between register and counter
    output [3:0] counter_out, // 4-bit output from the counter
    output [7:0] and_out    // 8-bit output from the functional module
);// D flip-flop module
    reg [7:0] reg_out;
    always @(negedge clk) begin
        if (reset) begin
            reg_out <= 8'h34;
        end else begin
            reg_out <= d;
        end
    end

    // Binary counter module
    reg [3:0] count;
    always @(posedge clk) begin
        if (reset || select) begin
            count <= 4'h0;
        end else begin
            count <= count + 1;
        end
    end

    // Functional module
    assign and_out = reg_out & count;

    // Control logic module
    assign counter_out = select ? count : 4'h0;

endmodule