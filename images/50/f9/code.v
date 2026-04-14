module top_module(
    input [15:0] data,
    input [15:0] control,
    input clk,
    input rst_n,
    output reg [15:0] R0,
    output reg [15:0] R1,
    output reg [15:0] R2,
    output reg [15:0] R3
);reg [1:0] write_sel;
reg [1:0] read1_sel;
reg [1:0] read2_sel;
reg [1:0] read3_sel;

always @(*) begin
    write_sel = control[15:14];
    read1_sel = control[7:4];
    read2_sel = control[3:2]; // Fixed this line to prevent using the same bits for both
    read3_sel = control[1:0]; // Changed for unique signal selection for each read
end

always @(posedge clk) begin
    if (!rst_n) begin
        R0 <= 16'h0000;
        R1 <= 16'h0000;
        R2 <= 16'h0000;
        R3 <= 16'h0000;
    end else begin
        case (write_sel)
            2'b00: R0 <= data;
            2'b01: R1 <= data;
            2'b10: R2 <= data;
            2'b11: R3 <= data;
        endcase
    end
end

// Change outputs to wires for read operations and use a separate wire for read output
wire [15:0] read_out1;
wire [15:0] read_out2;
wire [15:0] read_out3;

assign read_out1 = (read1_sel == 2'b00) ? R0 : (read1_sel == 2'b01) ? R1 : (read1_sel == 2'b10) ? R2 : (read1_sel == 2'b11) ? R3 : 16'hzzzz;
assign read_out2 = (read2_sel == 2'b00) ? R0 : (read2_sel == 2'b01) ? R1 : (read2_sel == 2'b10) ? R2 : (read2_sel == 2'b11) ? R3 : 16'hzzzz;
assign read_out3 = (read3_sel == 2'b00) ? R0 : (read3_sel == 2'b01) ? R1 : (read3_sel == 2'b10) ? R2 : (read3_sel == 2'b11) ? R3 : 16'hzzzz;

// If you need to output these read values, you can add output ports as necessary

endmodule