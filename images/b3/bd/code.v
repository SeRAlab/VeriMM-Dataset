module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [7:0] shift_reg_out, // Output from the shift register
    output reg [3:1] ena, // Enable signals for the upper three digits of the BCD counter
    output reg [7:0] final_output // Final output from the functional module
);reg [7:0] shift_reg;
    reg [3:0] bcd_counter;
    
    // Shift register with active high synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b01011010; // Reset to 0x5A
        end else begin
            shift_reg <= {shift_reg[6:0], shift_reg_out[0]}; // Corrected to use only the LSB of shift_reg_out
        end
    end
    
    // 4-digit BCD counter with enable signals generated using a priority encoder
    always @(posedge clk) begin
        if (reset) begin
            bcd_counter <= 4'b0000;
            ena <= 3'b000;
        end else begin
            if (bcd_counter == 4'b1001) begin
                bcd_counter <= 4'b0000;
                ena <= 3'b011;
            end else if (bcd_counter == 4'b0001) begin
                bcd_counter <= 4'b0010;
                ena <= 3'b101;
            end else if (bcd_counter == 4'b0011) begin
                bcd_counter <= 4'b0100;
                ena <= 3'b110;
            end else begin
                bcd_counter <= bcd_counter + 1;
                ena <= 3'b000;
            end
        end
    end
    
    // Functional module that adds the output of the shift register and the BCD counter
    always @(posedge clk) begin
        final_output <= shift_reg + bcd_counter;
    end

endmodule