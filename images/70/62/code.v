module top_module(reset, clk, m, trext, out, violation, done);input clk, reset, trext;
input [1:0] m;
output out, violation, done;

reg out, done, violation;

reg  [5:0] clkcount;
wire [5:0] bitcount, next_count;
assign bitcount = (trext == 6'd1) ? (clkcount) : (clkcount + 6'd12);


assign next_count = (bitcount > 6'd25) ? (clkcount) : (clkcount + 6'd1);

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    clkcount  <= 0;
    done      <= 0;
    out       <= 0;
    violation <= 0;

  end else begin
    if (m > 0) begin 
      if (bitcount == 0) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount == 12 & ~trext) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount <= 16) begin
        out       <= 0;
        violation <= 1;
      end else if (bitcount == 17) begin
        out       <= 1;
        violation <= 0;
      end else if (bitcount == 18) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount == 19) begin
        out       <= 1;
        violation <= 0;
      end else if (bitcount == 20) begin
        out       <= 1;
        violation <= 0;
      end else if (bitcount == 21) begin
        out       <= 1;
        violation <= 0;
        done      <= 1;
      end
      
    end else begin 
      if (bitcount <= 11) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount == 12) begin
        out       <= 1;
        violation <= 0;
      end else if (bitcount == 13) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount == 14) begin
        out       <= 1;
        violation <= 0;
      end else if (bitcount == 15) begin
        out       <= 0;
        violation <= 0;
      end else if (bitcount == 16) begin
        out       <= 0;
        violation <= 1;
      end else if (bitcount == 17) begin
        out       <= 1;
        violation <= 0;
        done      <= 1;
      end

    end 

    clkcount <= next_count;
  end 
end 
endmodule