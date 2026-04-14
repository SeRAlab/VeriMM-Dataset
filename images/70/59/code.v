module top_module(
    input clk,
    input [3:0] DATA_IN,
    input [1:0] SHIFT,
    output reg [3:0] Q
);reg [3:0] counter;
reg [3:0] shifted_counter;
reg [3:0] and_output;

always @(posedge clk) begin
    // Johnson counter sequence
    case(counter)
        4'b0001: counter <= 4'b0011;
        4'b0011: counter <= 4'b0111;
        4'b0111: counter <= 4'b1110;
        4'b1110: counter <= 4'b1100;
        4'b1100: counter <= 4'b1000;
        4'b1000: counter <= 4'b0001;
    endcase
    
    // Barrel shifter
    if (SHIFT == 2'b01) begin // Shift right
        shifted_counter[0] <= counter[3];
        shifted_counter[1] <= counter[0];
        shifted_counter[2] <= counter[1];
        shifted_counter[3] <= counter[2];
    end
    else if (SHIFT == 2'b10) begin // Shift left
        shifted_counter[0] <= counter[1];
        shifted_counter[1] <= counter[2];
        shifted_counter[2] <= counter[3];
        shifted_counter[3] <= counter[0];
    end
    else begin // No shift
        shifted_counter <= counter;
    end
    
    // Bitwise AND
    and_output <= shifted_counter & DATA_IN;
    
    // Output
    Q <= shifted_counter;
end

endmodule