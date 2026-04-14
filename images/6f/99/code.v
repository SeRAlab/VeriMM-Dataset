module top_module(ctrl,
    D0,
    D1,
    D2,
    S);input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  input [0:0]D2;
  output reg [0:0]S; // Change to reg type since it will be driven in an always block

  always @(*) begin
    case (ctrl)
      1'b0: S = D0;  // When ctrl is 0, select D0
      1'b1: begin
        // Adding the logic for D1 and D2 based on the ctrl
        if (D1) begin
          S = D1;  // When D1 is active, select D1
        end else if (D2) begin
          S = D2;  // When D2 is active, select D2
        end else begin
          S = 1'b0; // Default case
        end
      end
    endcase
  end
endmodule