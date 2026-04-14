module reset_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] new_value,
    output reg [7:0] out_value
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_value <= 8'hFF; // Set to an initial value when reset is high
    end else begin
        out_value <= new_value; // Update output to new value when reset is low
    end
end

endmodule