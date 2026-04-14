module top_module(
    output reg [3:0] douta,
    input clka,
    input ena,
    input [3:0] addra
);// Memory array declaration (16 entries of 4 bits each)
reg [3:0] mem [0:15];

// Initialize the memory contents
initial begin
    // Example initialization, you can modify according to your requirements
    mem[0] = 4'b0000;
    mem[1] = 4'b0001;
    mem[2] = 4'b0010;
    mem[3] = 4'b0011;
    mem[4] = 4'b0100;
    mem[5] = 4'b0101;
    mem[6] = 4'b0110;
    mem[7] = 4'b0111;
    mem[8] = 4'b1000;
    mem[9] = 4'b1001;
    mem[10] = 4'b1010;
    mem[11] = 4'b1011;
    mem[12] = 4'b1100;
    mem[13] = 4'b1101;
    mem[14] = 4'b1110;
    mem[15] = 4'b1111;
end

always @(posedge clka) begin
    if (ena) begin
        douta <= mem[addra]; // Output data from memory based on address
    end
end

endmodule