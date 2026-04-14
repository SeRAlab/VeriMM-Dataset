module dvfs_controller(
    input wire clk,
    input wire reset,
    input wire [4:0] load, // 5-bit load input
    output reg [2:0] frequency, // 3-bit frequency output
    output reg [1:0] voltage // 2-bit voltage output
);

    parameter LOAD_THRESHOLD = 5'd16; // Example threshold
    parameter FREQ_LOW = 3'b000;
    parameter FREQ_MED = 3'b001;
    parameter FREQ_HIGH = 3'b010;
    parameter VOLT_LOW = 2'b00;
    parameter VOLT_MED = 2'b01;
    parameter VOLT_HIGH = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= FREQ_LOW;
            voltage <= VOLT_LOW;
        end else begin
            if (load > LOAD_THRESHOLD) begin
                // High load, increase frequency and voltage
                frequency <= FREQ_HIGH;
                voltage <= VOLT_HIGH;
            end else begin
                // Low load, decrease frequency and voltage
                frequency <= FREQ_MED;
                voltage <= VOLT_MED;
            end
        end
    end
endmodule