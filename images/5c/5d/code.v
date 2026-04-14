module top_module(
    input clk_in,
    output reg D1,
    output reg D2,
    output reg D3,
    output reg D4
);//-- Numero de bits de los prescalers
parameter N0 = 1;
parameter N1 = 1;
parameter N2 = 2;
parameter N3 = 3;
parameter N4 = 4;

//-- Registros para los prescalers
reg [N0-1:0] prescaler0;
reg [N1-1:0] prescaler1;
reg [N2-1:0] prescaler2;
reg [N3-1:0] prescaler3;
reg [N4-1:0] prescaler4;

//-- Contadores para los prescalers
reg [N0-1:0] count0;
reg [N1-1:0] count1;
reg [N2-1:0] count2;
reg [N3-1:0] count3;
reg [N4-1:0] count4;

//-- Combinar los prescalers
wire [N0+N1-1:0] prescaler01;
wire [N0+N1+N2-1:0] prescaler012;
wire [N0+N1+N2+N3-1:0] prescaler0123;
wire [N0+N1+N2+N3+N4-1:0] prescaler01234;

assign prescaler01 = {prescaler0, prescaler1};
assign prescaler012 = {prescaler01, prescaler2};
assign prescaler0123 = {prescaler012, prescaler3};
assign prescaler01234 = {prescaler0123, prescaler4};

//-- Generar los clocks de salida
always @(posedge clk_in) begin
    count0 <= count0 + 1;
    if (count0 == prescaler0) begin
        count0 <= 0;
        D1 <= ~D1;
    end

    count1 <= count1 + 1;
    if (count1 == prescaler1) begin
        count1 <= 0;
        D1 <= ~D1;
        D2 <= ~D2;
    end

    count2 <= count2 + 1;
    if (count2 == prescaler2) begin
        count2 <= 0;
        D1 <= ~D1;
        D2 <= ~D2;
        D3 <= ~D3;
    end

    count3 <= count3 + 1;
    if (count3 == prescaler3) begin
        count3 <= 0;
        D1 <= ~D1;
        D2 <= ~D2;
        D3 <= ~D3;
        D4 <= ~D4;
    end

    count4 <= count4 + 1;
    if (count4 == prescaler4) begin
        count4 <= 0;
        D1 <= ~D1;
        D2 <= ~D2;
        D3 <= ~D3;
        D4 <= ~D4;
    end
end

//-- Establecer los prescaler valores
initial begin
    prescaler0 = 2**N0;
    prescaler1 = 2**N1;
    prescaler2 = 2**N2;
    prescaler3 = 2**N3;
    prescaler4 = 2**N4;
end

endmodule