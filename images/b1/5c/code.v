module top_module(
    output reg [7:0] douta,
    output reg [7:0] doutb,
    input clka,
    input clkb,
    input [13:0] addra,
    input [13:0] addrb,
    input [7:0] dina,
    input [7:0] dinb,
    input wea,
    input web,
    input ena
    );reg [7:0] mema [0:16383];
  reg [7:0] memb [0:16383];

  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        mema[addra] <= dina;
      end
      douta <= mema[addra];
    end
  end

  always @(posedge clkb) begin
    if (ena) begin
      if (web) begin
        memb[addrb] <= dinb;
      end
      doutb <= memb[addrb];
    end
  end

endmodule