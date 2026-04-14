module top_module(
    input clk,
    input reset, // Synchronous active-high reset 
    input [7:0] d0, // 8-bit input for the first register 
    input [7:0] d1, // 8-bit input for the second register 
    input [2:0] sel, // Select input to choose between register 1, register 2, and multiplexer output 
    input [7:0] data0, // 8-bit input for multiplexer 
    input [7:0] data1, // 8-bit input for multiplexer 
    input [7:0] data2, // 8-bit input for multiplexer 
    input [7:0] data3, // 8-bit input for multiplexer 
    input [7:0] data4, // 8-bit input for multiplexer 
    input [7:0] data5, // 8-bit input for multiplexer 
    output reg [7:0] q // Changed to reg type to enable procedural assignment 
);reg [7:0] reg0, reg1;
wire [7:0] mux_out;

// Register 0
always @(posedge clk) begin
    if (reset) begin
        reg0 <= 8'h34;
    end else begin
        reg0 <= d0;
    end
end

// Register 1
always @(posedge clk) begin
    if (reset) begin
        reg1 <= 8'h34;
    end else begin
        reg1 <= d1;
    end
end

// Multiplexer
assign mux_out = (sel == 3'b000) ? reg0 :
                 (sel == 3'b001) ? reg1 :
                 (sel == 3'b010) ? data0 :
                 (sel == 3'b011) ? data1 :
                 (sel == 3'b100) ? data2 :
                 (sel == 3'b101) ? data3 :
                 (sel == 3'b110) ? data4 :
                                   data5;

// Output
always @(mux_out, sel) begin
    case (sel)
        3'b000: q <= reg0;
        3'b001: q <= reg1;
        default: q <= mux_out;
    endcase
end

endmodule