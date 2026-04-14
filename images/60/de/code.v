module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input load,
    input ena,
    input [3:0] data,
    output [7:0] q
);reg [3:0] counter;
    reg [3:0] shift_reg [0:3];
    wire [3:0] shift_reg_out;
    reg [1:0] priority_ctrl;
    
    // Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0;
        end else begin
            counter <= counter + 1;
        end
    end
    
    // Shift Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all shift register values individually
            shift_reg[0] <= 4'b0;
            shift_reg[1] <= 4'b0;
            shift_reg[2] <= 4'b0;
            shift_reg[3] <= 4'b0;
        end else if (load) begin
            // Load data into the first register and shift others
            shift_reg[0] <= data;
            shift_reg[1] <= shift_reg[0];
            shift_reg[2] <= shift_reg[1];
            shift_reg[3] <= shift_reg[2];
        end else if (ena) begin
            // Shift left and fill with 0
            shift_reg[0] <= 4'b0;
            shift_reg[1] <= shift_reg[0];
            shift_reg[2] <= shift_reg[1];
            shift_reg[3] <= shift_reg[2];
        end
    end
    
    // Priority Control
    always @* begin
        if (load) begin
            priority_ctrl <= 2'b11;
        end else if (ena) begin
            priority_ctrl <= 2'b10;
        end else begin
            priority_ctrl <= 2'b01;
        end
    end
    
    // Output
    assign shift_reg_out = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
    assign q = shift_reg_out & 8'hAA; // Bitwise AND with constant value
    
endmodule