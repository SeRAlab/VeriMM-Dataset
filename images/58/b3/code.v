module top_module(
    input wire clk,
    input wire reset,
    output reg [7:0] address,
    output reg [7:0] out_ascii,
    output reg [7:0] out_bin_msb,
    output reg [7:0] out_bin_lsb
);reg [7:0] counter;
reg [7:0] ram [0:255];

// Generate address lines using counter
always @(posedge clk) begin
    if (reset) begin
        counter <= 8'b0;
        address <= 8'b0;
    end else begin
        counter <= counter + 1;
        address <= counter;
    end
end

// Store ASCII characters in RAM
initial begin
    ram[0] = 8'h30; // ASCII value for '0'
    ram[1] = 8'h31; // ASCII value for '1'
    ram[2] = 8'h32; // ASCII value for '2'
    // ...
    ram[255] = 8'hFF; // ASCII value for 'ÿ'
end

// Convert ASCII characters to binary values
always @(posedge clk) begin
    if (reset) begin
        out_ascii <= 8'b0;
        out_bin_msb <= 8'b0;
        out_bin_lsb <= 8'b0;
    end else begin
        out_ascii <= ram[address];
        out_bin_msb <= {1'b0, ram[address][6:0]}; // MSB expansion
        out_bin_lsb <= {ram[address][6:0], 1'b0}; // LSB expansion
    end
end

endmodule