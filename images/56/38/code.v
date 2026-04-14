module top_module(form, vec, A, B, C, D, Y1, Y2);input form;
  input[1:0] vec;
  input[31:0] A, B, C, D;
  output [31:0] Y1, Y2;

  reg [31:0]Y1_preci[3:0];
  reg [31:0]Y2_preci[3:0];

  generate
  genvar preci;
  for(preci = 0; preci < 3; preci = preci + 1) begin : precgen_add
    genvar biti;
    localparam integer nobits = (1 << (preci + 3));
    for(biti = 0; biti < 32/nobits; biti = biti + 1) begin : bitgen_add
      localparam integer lb = (biti + 1)*nobits - 1;
      localparam integer rb = biti*nobits;
		  always @(*) begin
		    if(!form) begin
            Y1_preci[preci][lb:rb] = A[lb:rb] + C[lb:rb];
            Y2_preci[preci][lb:rb] = B[lb:rb] + D[lb:rb];
			 end
          else begin
            {Y1_preci[preci][lb:rb], Y2_preci[preci][lb:rb]} = A[lb:rb] + B[lb:rb] + C[lb:rb];
          end
		  end
    end
  end
  endgenerate

  always@(*) begin
    {Y1_preci[3], Y2_preci[3]} = {A, B} + {C, D};
  end

  assign {Y1, Y2} = {Y1_preci[vec], Y2_preci[vec]};

endmodule