module state_space_controller (
    input wire clk,
    input wire [1:0] state,
    output reg [2:0] output_data
);
    
    always @(posedge clk) begin
        case (state)
            2'b00: output_data <= 3'b000; // State 0
            2'b01: output_data <= 3'b001; // State 1
            2'b10: output_data <= 3'b010; // State 2
            2'b11: output_data <= 3'b011; // State 3
            default: output_data <= 3'bxxx; // Undefined state
        endcase
    end
endmodule