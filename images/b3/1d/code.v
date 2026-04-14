module top_module(
    input wire clk_a,
    input wire clk_b,
    input wire [13:0] addr_a,
    input wire [13:0] addr_b,
    input wire [8:0] din_a,
    input wire [8:0] din_b,
    input wire we_a,
    input wire we_b,
    input wire en,
    output reg [8:0] dout_a,
    output reg [8:0] dout_b
);wire [8:0] ram_dout_a;
wire [8:0] ram_dout_b;
wire ram_en_a;
wire ram_en_b;
wire ram_we_a;
wire ram_we_b;

(* RAM_STYLE = "BLOCK" *) 
reg [8:0] ram [0:16383]; // Example for a 16K x 9-bit RAM

// Read operation for addr_a on clock_a
always @(posedge clk_a) begin
    if (en) begin 
        dout_a <= ram[addr_a]; // read from RAM
    end
end

// Write operation for addr_a on clock_a
always @(posedge clk_a) begin
    if (en && we_a) begin
        ram[addr_a] <= din_a; // write to RAM
    end
end

// Read operation for addr_b on clock_b
always @(posedge clk_b) begin
    if (en) begin
        dout_b <= ram[addr_b]; // read from RAM
    end
end

// Write operation for addr_b on clock_b
always @(posedge clk_b) begin
    if (en && we_b) begin
        ram[addr_b] <= din_b; // write to RAM
    end
end

endmodule