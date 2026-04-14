module top_module(
    douta,
    clka,
    addra,
    dina,
    wea
);// Define inputs and outputs
  output [11:0] douta;
  input clka;
  input [9:0] addra;
  input [11:0] dina;
  input wea;

  // Instantiate primitive RAMB18E1 module
  // Ensure correct parameters and mapping for your synthesis tool
  (* rom_style = "block" *) reg [11:0] ram [0:1023]; // Define a block RAM with 1024 entries
  reg [11:0] douta_reg;

  always @(posedge clka) begin
    if (wea) begin
      ram[addra] <= dina; // Write operation
    end
    douta_reg <= ram[addra]; // Read operation
  end
  
  assign douta = douta_reg;

endmodule