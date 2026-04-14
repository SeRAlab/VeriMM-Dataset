module top_module(
    input clk1, // clock input for port 1
    input clk2, // clock input for port 2
    input we1, // write enable input for port 1
    input we2, // write enable input for port 2
    input re1, // read enable input for port 1
    input re2, // read enable input for port 2
    input [3:0] addr1, // address input for port 1
    input [3:0] addr2, // address input for port 2
    input [7:0] data1, // data input for port 1
    input [7:0] data2, // data input for port 2
    output reg [7:0] q1, // data output for port 1
    output reg [7:0] q2 // data output for port 2
);reg [7:0] mem [0:15]; // 16x8-bit memory

always @(posedge clk1) begin
    if (we1) begin // write to memory for port 1
        mem[addr1] <= data1;
    end
    if (re1) begin // read from memory for port 1
        q1 <= mem[addr1];
    end
end

always @(posedge clk2) begin
    if (we2) begin // write to memory for port 2
        mem[addr2] <= data2;
    end
    if (re2) begin // read from memory for port 2
        q2 <= mem[addr2];
    end
end

endmodule