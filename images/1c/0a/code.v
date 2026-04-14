module eeprom (
    input wire clk,
    input wire we,      // Write Enable
    input wire re,      // Read Enable
    input wire [7:0] din, // Data Input
    output reg [7:0] dout // Data Output
);

    reg [7:0] memory; // Internal memory register

    always @(posedge clk) begin
        if (we) begin
            memory <= din; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            dout <= memory; // Read data from memory
        end
    end

endmodule