module top_module(
    address,
    byteena,
    clock,
    data,
    rden,
    wren,
    q
);input   [9:0]   address;
input   [3:0]   byteena;
input           clock;
input   [31:0]  data;
input           rden;
input           wren;
output  reg [31:0]  q;  // Change 'output' to 'output reg' for correct assignment

reg [31:0] mem [0:1023];

always @(posedge clock) begin
    if (rden == 1'b1 && wren == 1'b0) begin
        q <= {mem[address][31:24], mem[address][23:16], mem[address][15:8], mem[address][7:0]} & {byteena, byteena, byteena, byteena}; // Bitwise operation with byteena
    end
    if (wren == 1'b1 && rden == 1'b0) begin
        if (byteena == 4'b1111) begin
            mem[address] <= data;
        end else begin
            if (byteena[0]) begin
                mem[address][7:0] <= data[7:0];
            end
            if (byteena[1]) begin
                mem[address][15:8] <= data[15:8];
            end
            if (byteena[2]) begin
                mem[address][23:16] <= data[23:16];
            end
            if (byteena[3]) begin
                mem[address][31:24] <= data[31:24];
            end
        end
    end
end

endmodule