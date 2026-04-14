module LDO_Control(
    input wire clk,
    input wire rst,
    input wire vin,           // Input voltage (1 bit for simplicity)
    input wire vref,          // Reference voltage (1 bit for simplicity)
    output reg enable         // Output enable signal
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            enable <= 1'b0;
        end else if (vin > vref) begin
            enable <= 1'b1;
        end else if (vin <= vref) begin
            enable <= 1'b0;
        end
    end
endmodule