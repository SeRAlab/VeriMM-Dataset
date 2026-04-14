module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);reg [99:0] shift_reg;
    reg [2:0] shift_amt;
    wire [99:0] shifted_data;

    // Barrel shifter
    assign shifted_data = {shift_reg[shift_amt[2:0]], shift_reg} >> shift_amt;

    // Multiplexer for rotating
    always @(*) begin
        case (ena)
            2'b00: q = shifted_data; // No rotation
            2'b01: q = {shifted_data[2:0], shifted_data[99:3]}; // Rotate left by 3 bits
            2'b10: q = {shifted_data[97:0], shifted_data[99:98]}; // Rotate right by 3 bits
            2'b11: q = shift_reg; // Load
        endcase
    end

    // Load data
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
            shift_amt <= 3;
        end else begin
            shift_reg <= shifted_data;
            shift_amt <= ena == 2'b10 ? -3 : 3; // Negative shift amount for right rotation
        end
    end

endmodule