module top_module(
    input CLK,
    input DS,
    input ED,
    input MPYJ,
    input [31:0] DR,
    input [31:0] DI,
    output reg [31:0] DOR,  // Changed to reg
    output reg [31:0] DOI   // Changed to reg
);reg signed [33:0] dx5;
reg signed [33:0] dx3;
reg signed [31:0] dii;
reg signed [31:0] dt;
wire signed [34:0] dx5p;
wire signed [34:0] dot;
reg edd;
reg edd2;
reg edd3;
reg mpyjd;
reg mpyjd2;
reg mpyjd3;
reg [31:0] doo;
reg [31:0] droo;

always @(posedge CLK) begin
    if (ED) begin
        edd <= DS;
        edd2 <= edd;
        edd3 <= edd2;
        mpyjd <= MPYJ;
        mpyjd2 <= mpyjd;
        mpyjd3 <= mpyjd2;
        if (DS) begin
            dx5 <= DR + (DR >>> 2);
            dx3 <= DR + (DR >>> 1);
            dt <= DR;
            dii <= DI;
        end else begin
            dx5 <= dii + (dii >>> 2);
            dx3 <= dii + (dii >>> 1);
            dt <= dii;
        end
        doo <= dot >>> 2;
        droo <= doo;
        if (edd3) begin
            if (mpyjd3) begin
                DOR <= doo;
                DOI <= -droo;
            end else begin
                DOR <= droo;
                DOI <= doo;
            end
        end
    end
end

assign dx5p = (dt << 1) + (dx5 >>> 3);
assign dot = (dx5p + (dt >>> 7) + (dx3 >>> 11));

endmodule