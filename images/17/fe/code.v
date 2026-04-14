module deserializer (
    input clk,
    input rst,
    input [7:0] din,
    output reg [15:0] dout,
    output reg valid
);
    reg [3:0] count; // Count the number of clock cycles

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 16'b0;
            count <= 4'b0;
            valid <= 1'b0;
        end else begin
            dout <= {din, dout[15:8]}; // Shift in the new data
            count <= count + 1;
            if (count == 4'd1) begin
                valid <= 1'b1; // After 2 clock cycles, the output is valid
            end else if (count == 4'd2) begin
                count <= 4'b0; // Reset count after 2 cycles
                valid <= 1'b0; // Reset valid
            end
        end
    end
endmodule