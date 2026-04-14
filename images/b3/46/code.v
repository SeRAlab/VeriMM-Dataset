module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] write_data, // 8-bit input for the RAM module
    input [7:0] write_addr, // Address input for the RAM module
    input write_en, // Write enable input for the RAM module
    input [31:0] in, // Input signal for the input signal detection module
    input select, // Select input to choose between RAM module and functional module
    input [7:0] read_addr, // Address input for the functional module
    input read_en, // Read enable input for the functional module
    output reg [7:0] read_data // 8-bit output from the active module
);// Dual-port RAM module
reg [3:0] ram [7:0];

// Input signal detection module
wire [31:0] input_detect;

// Additional functional module
reg [7:0] func_out;

// Control logic module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_data <= 8'b0;
    end else begin
        if (select) begin
            read_data <= func_out;
        end else begin
            read_data <= ram[read_addr];
        end
    end
end

// Dual-port RAM module
always @(posedge clk) begin
    if (write_en) begin
        ram[write_addr] <= write_data[3:0];
    end
end

// Input signal detection module
assign input_detect = (in ^ {in[31:1], 1'b0}) & ~in;

// Additional functional module
always @(posedge clk) begin
    if (read_en) begin
        func_out <= ram[input_detect[7:0]];
    end
end

endmodule