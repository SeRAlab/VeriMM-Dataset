module top_module(
reset,
sysclk,
ival
);input reset, sysclk, ival;

wire reset;
wire sysclk;
wire ival;


reg [13:0] foo;
wire [2:0] baz;
reg [22:0] bam;
wire [5:3] out_i;
wire [8:0] input_status;
wire enable; wire debug; wire aux; wire outy; wire dv; wire value;

  
  assign input_status = {foo[9:4],((baz[3:0] & foo[3:0] | (( ~baz[3:0] & bam[3:0]))))};
  
  assign out_i = ((enable & ((aux ^ outy)))) | ((debug & dv &  ~enable)) | (( ~debug &  ~enable & value));
  
  always @(negedge reset or negedge sysclk) begin
    if((reset != 1'b 0)) begin
      foo <= {14{1'b0}};
    end else begin
      foo[3 * ((2 - 1))] <= (4 * ((1 + 2)));
      bam[13:0] <= foo;
    end
  end


endmodule