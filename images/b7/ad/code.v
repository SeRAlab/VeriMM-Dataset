module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    input select,     // Select input to choose between register and counter
    input write_en,   // Write enable signal for the RAM
    input [7:0] write_addr, // Write address for the RAM
    input [3:0] write_data, // Write data for the RAM
    input read_en,    // Read enable signal for the RAM
    input [7:0] read_addr,  // Read address for the RAM
    output reg [7:0] q,   // 8-bit output from the active module
    output reg [3:0] counter_out, // Output from the counter module
    output reg [3:0] ram_out // Output from the RAM module
);reg [7:0] reg_out;
reg [3:0] counter;

// 8-bit register module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        reg_out <= 8'h34;
    end else begin
        reg_out <= d;
    end
end

// 4-bit counter module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'b0000;
    end else begin
        counter <= counter + 1;
    end
end

// Control logic module
always @(posedge clk) begin
    if (select) begin
        q <= reg_out;
    end else begin
        q <= counter;
    end
end

// Additional functional module
assign counter_out = counter + reg_out[3:0];

// True dual-port RAM module
reg [3:0] ram [0:7];

always @(posedge clk) begin
    if (write_en) begin
        ram[write_addr[2:0]] <= write_data;
    end
    if (read_en) begin
        ram_out <= ram[read_addr[2:0]];
    end
end

endmodule