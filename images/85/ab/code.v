module top_module(
    input clk,
    input reset,
    input [7:0] d,
    input [2:0] select,
    input [2:0] vec,
    output [7:0] q
);// Problem 1: Shift Register Module
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], d};
        end
    end
    
    // Problem 2: Multiplexer Module
    reg [7:0] output_vec;
    always @(vec) begin
        case (vec)
            3'b000: output_vec <= 8'b00000001;
            3'b001: output_vec <= 8'b00000010;
            3'b010: output_vec <= 8'b00000100;
            3'b011: output_vec <= 8'b00001000;
            3'b100: output_vec <= 8'b00010000;
            3'b101: output_vec <= 8'b00100000;
            3'b110: output_vec <= 8'b01000000;
            3'b111: output_vec <= 8'b10000000;
        endcase
    end
    
    // Additional Functional Module
    reg [7:0] final_output;
    always @(shift_reg, output_vec) begin
        final_output <= shift_reg | output_vec;
    end
    
    // Additional Control Logic Module
    reg [1:0] active_module;
    always @(select) begin
        case (select)
            3'b000: active_module <= 2'b01; // Shift Register Active
            3'b001: active_module <= 2'b10; // Multiplexer Active
            default: active_module <= 2'b00; // Both Inactive
        endcase
    end
    
    // Output
    assign q = (active_module == 2'b01) ? shift_reg : final_output;

endmodule