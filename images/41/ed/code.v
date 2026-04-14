module top_module(
    input clk,
    input rst,
    input shift_dir,
    input parallel_load,
    input [3:0] parallel_input,
    input serial_input,
    input clear_input,
    output serial_output,
    output [3:0] parallel_output
);reg [3:0] reg_value;
    wire [3:0] reg_value_shifted;
    wire [3:0] reg_value_loaded;
    wire [3:0] reg_value_cleared;

    // Shift the register left or right based on the shift_dir input
    assign reg_value_shifted = shift_dir ? {reg_value[2:0], 1'b0} : {1'b0, reg_value[3:1]};

    // Load the register with the parallel_input value when parallel_load is asserted
    assign reg_value_loaded = parallel_load ? parallel_input : reg_value_shifted;

    // Clear the register to all zeros when clear_input is asserted
    assign reg_value_cleared = clear_input ? 4'h0 : reg_value_loaded;

    // Output the serial_output value as the MSB of the register
    assign serial_output = reg_value[3];

    // Output the parallel_output value as the entire register
    assign parallel_output = reg_value;

    // Register the value of the shift register on the positive edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            reg_value <= 4'h0;
        end else begin
            reg_value <= reg_value_cleared;
        end
    end

endmodule