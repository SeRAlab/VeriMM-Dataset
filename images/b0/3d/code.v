module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the shift register
    input select, // Select input to choose between register and counter
    output reg [7:0] q, // Changed to reg to allow assignment in the always block
    output [3:0] counter_q, // 4-bit output from the counter
    output [7:0] xor_out // 8-bit output from the XOR module
);// Define the 8-bit shift register
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else if (select) begin
            shift_reg <= {shift_reg[6:0], d};
        end else begin
            shift_reg <= {d, shift_reg[7]};
        end
    end
    
    // Define the 4-bit counter
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0;
        end else if (!select && counter == 4'hf) begin
            counter <= 4'b0;
        end else if (!select) begin
            counter <= counter + 1;
        end
    end
    
    // Define the XOR module
    reg [7:0] xor_reg;
    always @(posedge clk) begin
        if (reset) begin
            xor_reg <= 8'b0;
        end else begin
            xor_reg <= shift_reg ^ {4'b0, counter};
        end
    end
    
    // Define the multiplexer to select between the shift register and the counter
    always @(posedge clk) begin
        if (select) begin
            q <= shift_reg;
        end else begin
            q <= {4'b0, counter};
        end
    end
    
    // Assign the outputs
    assign counter_q = counter;
    assign xor_out = xor_reg;
    
endmodule