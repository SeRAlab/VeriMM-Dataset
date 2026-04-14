module top_module(
    input CLKIN,
    input RST,
    input [3:0] BAUD,
    output CLKOUT
    );parameter B300    = 19'b1010001011000010100;
    parameter B600    = 19'b0101000101100001010;
    parameter B1200   = 19'b0010100010110000100;
    parameter B2400   = 19'b0001010001011000010;
    parameter B4800   = 19'b0000101000101100000;
    parameter B9600   = 19'b0000010100010110000;
    parameter B19200  = 19'b0000001010001010111;
    parameter B38400  = 19'b0000000101000101011;
    parameter B57600  = 19'b0000000011011000111;
    parameter B115200 = 19'b0000000001101100011; 
     

    
    reg [19:0] clk_cntr;

    
    reg [19:0] baud_rate;


    
    reg out_clk;
    

    
    always @ (BAUD, RST) begin
      if(RST == 1'b1) begin
        baud_rate <= B9600;
      end
      else begin
        case(BAUD)
          4'h0    : baud_rate <= B300;
          4'h1    : baud_rate <= B600;
          4'h2    : baud_rate <= B1200;
          4'h3    : baud_rate <= B2400;
          4'h4    : baud_rate <= B4800;
          4'h5    : baud_rate <= B9600;
          4'h6    : baud_rate <= B19200;
          4'h7    : baud_rate <= B38400;
          4'h8    : baud_rate <= B57600;
          4'h9    : baud_rate <= B115200;
          default : baud_rate <= B9600;
        endcase   
      end
    end


    
    always @ (posedge CLKIN) begin
      if(RST == 1'b1) begin
        clk_cntr <= 0;
        out_clk <= 0;
      end
      else if(clk_cntr == baud_rate) begin
        clk_cntr <= 0;
        out_clk <= ~out_clk;
      end
      else begin
        clk_cntr <= clk_cntr + 1'b1;
      end
    end

   assign CLKOUT = out_clk; 
    
    

endmodule