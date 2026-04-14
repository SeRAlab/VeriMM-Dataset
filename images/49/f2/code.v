module top_module(
    input clk,
    input rst_n,
    input data_in, // Input data for the RAM and shift register
    input shift_en, // Enable signal for the shift register
    output reg [3:0] shift_out, // Output from the shift register
    output reg [3:0] ram_out // Output from the RAM at the current read address
);// Dual-port RAM module
reg [3:0] ram [7:0];
integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            ram[i] <= 4'b0;
        end
    end
end

// Write operation
reg [2:0] write_addr;
reg [3:0] write_data;

always @(posedge clk) begin
    if (write_addr < 8) begin
        ram[write_addr] <= write_data;
    end
end

// Read operation
reg [2:0] read_addr;
reg [3:0] read_data;

always @(posedge clk) begin
    if (read_addr < 8) begin
        read_data <= ram[read_addr];
    end
end

// Shift register module
reg [3:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end else if (shift_en) begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Output assignments
assign shift_out = shift_reg[0];
assign ram_out = read_data;

endmodule