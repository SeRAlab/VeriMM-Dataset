module dram_cell (
    input wire clk,
    input wire W,
    input wire R,
    input wire D,
    output reg Q
);
    reg [3:0] counter; // Counter to simulate capacitor discharge timing
    reg stored_value;
    
    initial begin
        Q = 1'b0;
        counter = 4'b0000;
    end
    
    always @(posedge clk) begin
        if (W) begin
            stored_value <= D; // Store the input data
            counter <= 4'b1111; // Reset counter to hold value
        end
        if (counter > 0) begin
            counter <= counter - 1; // Decrease counter
            Q <= stored_value; // Maintain stored value
        end else begin
            Q <= 1'b0; // Discharge capacitor
        end
    end
endmodule