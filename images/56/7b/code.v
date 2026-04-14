module top_module(
    input [13:0] addra,
    input [13:0] addrb,
    input [7:0] dina,
    input [0:0] wea,
    input ena,
    input enb,
    input clka,
    input clkb,
    output reg [7:0] douta,
    output reg [7:0] doutb
);reg [7:0] mem [0:16383];

always @(posedge clka) begin
    if (ena) begin
        if (wea) begin
            mem[addra] <= dina;
        end
        douta <= mem[addra];
    end
end

always @(posedge clkb) begin
    if (enb) begin
        if (wea) begin
            mem[addrb] <= dina;
        end
        doutb <= mem[addrb];
    end
end

endmodule