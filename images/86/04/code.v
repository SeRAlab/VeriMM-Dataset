module top_module(
    clka,
    ena,
    wea,
    addra,
    dina,
    douta
);input clka;
input ena;
input [1:0] wea;
input [11:0] addra;
input [15:0] dina;
output [15:0] douta;

reg [15:0] mem [0:4095]; // Create a memory array of 4096 x 16-bit registers
reg [15:0] douta_reg;

always @(posedge clka) begin
    if (ena) begin
        if (wea[0]) mem[addra][7:0] <= dina[7:0]; // Write lower 8 bits if wea[0] is high
        if (wea[1]) mem[addra][15:8] <= dina[15:8]; // Write upper 8 bits if wea[1] is high
    end
    douta_reg <= mem[addra]; // Read data on posedge and update douta_reg
end

assign douta = douta_reg; // Connect douta_register to the output

endmodule