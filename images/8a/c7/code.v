module top_module(
    input clock,
    input reset,
    input [1:0] reg_write_enable,
    input [1:0] reg_write_address,
    input [31:0] reg_write_data,
    output [31:0] reg_read_data_1,
    output [31:0] reg_read_data_2,
    output reg [31:0] hi_register, // Changed to reg
    output reg [31:0] lo_register  // Changed to reg
);reg [31:0] storage [0:3];

always @(posedge clock) begin
    if (reset) begin
        storage[0] <= 0;
        storage[1] <= 0;
        storage[2] <= 0;
        storage[3] <= 0;
        hi_register <= 0;
        lo_register <= 0;
    end else begin
        if (reg_write_enable[0]) begin
            storage[reg_write_address[0]] <= reg_write_data;
        end
        if (reg_write_enable[1]) begin
            storage[reg_write_address[1]] <= reg_write_data;
        end
        hi_register <= {16'h0000, reg_write_data[31:16]};
        lo_register <= {16'h0000, reg_write_data[15:0]};
    end
end

assign reg_read_data_1 = storage[1];
assign reg_read_data_2 = storage[2];

endmodule