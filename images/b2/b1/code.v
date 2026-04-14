module top_module(
  input CLK,
  input FM,
  output SSC
);reg [31:0] counter;
  reg [31:0] triangle_wave;
  reg [31:0] phase;
  reg [31:0] SSC_reg;
  wire CLK_div2;
  wire CLK_div4;
  wire CLK_div8;
  wire CLK_div16;
  wire CLK_div32;
  wire CLK_div64;
  wire CLK_div128;
  wire CLK_div256;
  wire CLK_div512;
  wire CLK_div1024;
  
  assign CLK_div2 = CLK;
  assign CLK_div4 = CLK_div2 & CLK_div2;
  assign CLK_div8 = CLK_div4 & CLK_div4;
  assign CLK_div16 = CLK_div8 & CLK_div8;
  assign CLK_div32 = CLK_div16 & CLK_div16;
  assign CLK_div64 = CLK_div32 & CLK_div32;
  assign CLK_div128 = CLK_div64 & CLK_div64;
  assign CLK_div256 = CLK_div128 & CLK_div128;
  assign CLK_div512 = CLK_div256 & CLK_div256;
  assign CLK_div1024 = CLK_div512 & CLK_div512;
  
  always @(posedge CLK_div1024) begin
    counter <= counter + 1;
    if (counter == 1023) begin
      counter <= 0;
      triangle_wave <= triangle_wave + FM;
      if (triangle_wave == 32767) begin
        triangle_wave <= 0;
      end
    end
  end
  
  always @(posedge CLK_div2) begin
    phase <= phase + triangle_wave;
    if (phase >= 65536) begin
      phase <= phase - 65536;
    end
    SSC_reg <= (phase >= 32768) ? ~CLK : CLK;
  end
  
  assign SSC = SSC_reg;
  
endmodule