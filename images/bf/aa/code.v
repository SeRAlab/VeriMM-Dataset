module top_module(
  input x,
  input y,
  output reg z // change wire to reg to allow assignment in always block
);// State encoding conversion
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state
reg [1:0] state = A;

// State transition logic
always @ (x or y or state)
begin
  case (state)
    A: if (x == 0 && y == 0) begin state <= B; z <= 0; end
       else begin state <= A; z <= 1; end
    B: if (x == 0 && y == 1) begin state <= C; z <= 1; end
       else begin state <= A; z <= 1; end
    C: if (x == 1 && y == 0) begin state <= D; z <= 0; end
       else begin state <= A; z <= 1; end
    D: if (x == 1 && y == 1) begin state <= A; z <= 1; end
       else begin state <= A; z <= 1; end
    default: begin state <= A; z <= 1; end
  endcase
end

endmodule