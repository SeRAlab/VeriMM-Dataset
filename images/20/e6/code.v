module I2C_Controller (
    input wire clk,          // Input clock signal
    input wire control,      // Control signal (0: write, 1: read)
    output reg SCL          // SCL output signal
);
    reg [1:0] state;        // State variable

    always @(posedge clk) begin
        if (state == 2'b00) begin
            SCL <= 0;
            state <= 2'b01; // Move to next state
        end else if (state == 2'b01) begin
            SCL <= 1;
            if (control) begin
                state <= 2'b10; // Read operation
            end else begin
                state <= 2'b11; // Write operation
            end
        end else if (state == 2'b10 || state == 2'b11) begin
            SCL <= ~SCL; // Toggle SCL for read/write
        end
    end
endmodule