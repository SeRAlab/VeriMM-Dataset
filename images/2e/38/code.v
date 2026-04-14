module dvfs_controller (
    input wire [7:0] load,
    input wire clk,
    input wire reset,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        voltage <= 2'b00;
        frequency <= 2'b00;
    end else begin
        if (load < 8'd64) begin
            voltage <= 2'b00;  // 1V
            frequency <= 2'b00; // 100MHz
        end else if (load < 8'd128) begin
            voltage <= 2'b01;  // 1.5V
            frequency <= 2'b01; // 200MHz
        end else if (load < 8'd192) begin
            voltage <= 2'b10;  // 2V
            frequency <= 2'b10; // 300MHz
        end else begin
            voltage <= 2'b11;  // 2.5V
            frequency <= 2'b11; // 400MHz
        end
    end
end

endmodule