module top_module(
  input clk,
  input reset_n,
  input din,
  output dout
);parameter depth = 3;

  (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON  "} *) reg din_s1;

  (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [depth-2:0] dreg;    

  `ifdef __ALTERA_STD__METASTABLE_SIM
  reg[31:0]  RANDOM_SEED = 123456;      
  wire  next_din_s1;
  wire  dout;
  reg   din_last;
  reg          random;
  event metastable_event; // hook for debug monitoring

  initial begin
    $display("%m: Info: Metastable event injection simulation mode enabled");
  end
   
  always @(posedge clk) begin
    if (reset_n == 0)
      random <= $random(RANDOM_SEED);
    else
      random <= $random;
  end

  assign next_din_s1 = (din_last ^ din) ? random : din;   

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) 
      din_last <= 1'b0;
    else
      din_last <= din;
  end

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) 
      din_s1 <= 1'b0;
    else
      din_s1 <= next_din_s1;
  end
   
  `else 
  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) 
      din_s1 <= 1'b0;
    else
      din_s1 <= din;
  end
  `endif

  generate
    if (depth < 3) begin
      always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) 
          dreg <= {depth-1{1'b0}};            
        else
          dreg <= din_s1;
      end         
    end else begin
      always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) 
          dreg <= {depth-1{1'b0}};
        else
          dreg <= {dreg[depth-3:0], din_s1};
      end
    end
  endgenerate

  assign dout = dreg[depth-2];
   
endmodule