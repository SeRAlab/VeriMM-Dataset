module top_module(reset, clock, in, Res, Cout);input reset;
  input clock;
  input [3:0] in;
  output [3:0] Res;
  output Cout;

  reg [3:0] Res;
  reg Cout;

  parameter [1:0] over = 0, normal = 1, init = 2;
  reg [1:0] current_state, next_state;

  always @(posedge clock or posedge reset)
  begin: SYNCH
    if (reset == 1'b1)
       current_state <= init;
    else
       current_state <= next_state;
  end

  always @(current_state or in)
  begin: COMBIN
     case (current_state)
        over:
        begin
          Res <= 4'b0000;
          Cout <= 1'b1;

        end

        normal:
        begin
          Res <= in - 4'b0001;
          Cout <= 1'b0;

        end

        init:
        begin
          if (in == 4'b0000)
             begin
             next_state <= over;
             end
          else if (in != 4'b0000)
             begin
             next_state <= normal;
             end
        end


        default:
          next_state <= init;
     endcase
  end

endmodule