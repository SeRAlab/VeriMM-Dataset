module sample_rate_conversion (
    input clk,
    input rst,
    input din,
    output reg [1:0] dout
);
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 2'b00;
            counter <= 2'b00;
        end else begin
            if (counter == 2'b01) begin
                dout <= {din, din}; // Convert 1-bit to 2-bit
                counter <= 2'b00;
            end else begin
                dout <= dout; // Hold the value
                counter <= counter + 1;
            end
        end
    end
endmodule