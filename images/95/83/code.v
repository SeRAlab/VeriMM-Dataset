module top_module(clka, wea, web, addra, addrb, dina, dinb, douta);input clka;
  input wea, web;
  input [11:0]addra, addrb;
  input [11:0]dina, dinb;
  output [11:0]douta;
  
  reg [11:0] memory [0:4095];
  reg [11:0] selected_data;
  
  always @(posedge clka) begin
    if (wea) begin
      if (addra < 4096) begin
        memory[addra] <= dina;
      end
    end
    else if (web) begin
      if (addrb < 4096) begin
        memory[addrb] <= dinb;
      end
    end
    else begin
      if (addra < 4096) begin
        selected_data <= memory[addra];
      end
      else begin
        selected_data <= 12'b0;
      end
    end
  end
  
  assign douta = selected_data;
  
endmodule