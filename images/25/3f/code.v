module PISO_Shift_Register (
    input wire clk,
    input wire load,
    input wire [4:0] data,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer cnt;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;  // Load parallel data into shift register
            cnt <= 0;           // Reset counter
        end else begin
            if (cnt < 5) begin
                serial_out <= shift_reg[4]; // Shift out the MSB to serial_out
                shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
                cnt <= cnt + 1; // Increment counter
            end else begin
                serial_out <= 1'b0; // After shifting all bits, set output to 0
            end
        end
    end
endmodule