module top_module(
    input clk,
    input rst_n,
    input up_down,
    input [3:0] load_data,
    input [1:0] SHIFT,
    output reg [3:0] data_out,
    output reg overflow
);reg [3:0] count;
reg [3:0] shifted_count;
wire [3:0] and_output;
reg load; // Declare load signal

// Up/Down Counter Module
always @(posedge clk) begin
    if (!rst_n) begin
        count <= 4'b0000;
    end else if (load) begin
        count <= load_data;
    end else if (up_down) begin
        count <= count + 4'b0001;
    end else begin
        count <= count - 4'b0001;
    end
end

// Barrel Shifter Module
always @(posedge clk) begin
    if (!rst_n) begin
        shifted_count <= 4'b0000;
    end else begin
        case (SHIFT)
            2'b00: shifted_count <= count << 1;
            2'b01: shifted_count <= count >> 1;
            2'b10: shifted_count <= count << 2;
            2'b11: shifted_count <= count >> 2;
        endcase
    end
end

// AND Module
assign and_output = shifted_count & count;
assign data_out = and_output;

// Overflow Control Logic Module
always @(posedge clk) begin
    if (!rst_n) begin
        overflow <= 1'b0;
    end else if (count == 4'b1111 && up_down) begin
        overflow <= 1'b1;
    end else if (count == 4'b0000 && !up_down) begin
        overflow <= 1'b1;
    end else begin
        overflow <= 1'b0;
    end
end

endmodule