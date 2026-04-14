module top_module(
    clka,
    ena,
    wea,
    addra,
    dina,
    douta
);input clka;
input ena;
input [0 : 0] wea;
input [6 : 0] addra;
input [31 : 0] dina;
output [31 : 0] douta;

reg [31:0] cache_mem [0:127];
reg [31:0] douta_reg;

always @(posedge clka) begin
    if (ena) begin
        if (wea == 1'b1) begin
            cache_mem[addra] <= dina;
        end else begin
            douta_reg <= cache_mem[addra];
        end
    end
end

assign douta = douta_reg;

endmodule