module I2C_Controller (
    input wire clk,
    input wire EN,
    output reg SCL,
    output reg START,
    output reg SDA
);
    reg [3:0] count;

    always @(posedge clk) begin
        if (EN) begin
            START <= 1'b1;  // Start condition
            count <= count + 1;
            SCL <= ~SCL;     // Toggle clock
            if (count == 4'd8) begin
                SDA <= 1'b0; // Sending data (logic low)
                count <= 4'd0; // Reset count
            end
        end else begin
            START <= 1'b0; // Stop condition when EN is low
            SCL <= 1'b0;   // Ensure SCL is low
            SDA <= 1'b1;   // Release SDA line
            count <= 4'd0; // Reset count
        end
    end
endmodule