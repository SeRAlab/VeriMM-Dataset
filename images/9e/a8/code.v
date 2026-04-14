module top_module(
    input clk,          // Clock input
    input reset,        // Synchronous active-high reset
    input [7:0] d,      // 8-bit input for the register
    input [1:0] select, // Select input to choose between register and counter
    output [11:0] q     // 12-bit output from the functional module
);// Register module with active high synchronous reset
    reg [7:0] reg_out;
    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'h34;
        end else begin
            reg_out <= d;
        end
    end

    // Counter module with synchronous reset
    reg [3:0] counter_out;
    always @(posedge clk) begin
        if (reset) begin
            counter_out <= 4'h0;
        end else begin
            counter_out <= counter_out + 1;
        end
    end

    // Control logic module to select between register and counter output
    reg [7:0] selected_input; // Changed to reg type
    always @(*) begin
        if (select == 2'b00) begin
            selected_input = reg_out;
        end else if (select == 2'b01) begin
            selected_input = {4'b0, counter_out}; // Ensure the size matches
        end else begin
            selected_input = 8'h0;
        end
    end

    // Functional module to add the selected inputs
    wire [11:0] added_output;
    assign added_output = {4'b0, selected_input} + {4'b0, reg_out};

    // Output from the functional module
    assign q = added_output;

endmodule