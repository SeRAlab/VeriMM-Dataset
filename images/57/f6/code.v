module top_module(
    input clk,
    input rst,
    input [3:0] data,
    input [1:0] shift,
    output reg [3:0] sum
);reg [3:0] shifted_data;
reg [3:0] counter;

always @(posedge clk) begin
    if (rst) begin
        shifted_data <= 4'b0;
        counter <= 4'b0;
        sum <= 4'b0;
    end else begin
        case (shift)
            2'b00: shifted_data <= data;                // No shift
            2'b01: shifted_data <= {data[2:0], data[3]}; // Shift left by 1
            2'b10: shifted_data <= {data[1:0], data[3:2]}; // Shift left by 2
            2'b11: shifted_data <= {data[0], data[3:1]}; // Wrap around (Shift left by 3)
            default: shifted_data <= data;              // Default case
        endcase
        
        counter <= counter + 1;
        sum <= shifted_data + counter;
    end
end

endmodule