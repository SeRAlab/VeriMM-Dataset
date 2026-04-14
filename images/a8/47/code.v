module top_module(
  input clk,
  input reset,
  input [13:0] e,
  input [31:0] b,
  output reg [13:0] q,
  output reg rb
);reg [13:0] r_b, r_e, r_c, r_qx;
reg rr_b, rr_e;
wire e2;
wire [13:0] cx;

// Create the register (flip-flop) for the initial/1st stage
always@(posedge clk)
begin
  if(reset)
  begin
    r_b <= 0;
    r_e <= 0;
  end
  else
  begin
    r_e <= e;
    r_b <= b[13:0];  // Ensure only 14 bits are assigned
  end
end

// Create the register (flip-flop) for the 2nd stage
always@(posedge clk)
begin
  if(reset)
  begin
    r_c <= 0;
    rr_e <= 0;
    rr_b <= 0;
  end
  else
  begin
    r_c <= cx;
    rr_e <= r_e[0];  // Assign only the least significant bit if rr_e is a single bit
    rr_b <= r_b[0];  // Assign only the least significant bit if rr_b is a single bit
  end
end

// Create the register (flip-flop) for the 3rd stage
always@(posedge clk)
begin
  if(reset)
  begin
    r_qx <= 0;
    rb <= 0;
  end
  else
  begin
    r_qx <= cx;
    rb <= rr_b;
  end
end

// Assign value to q
always @(*) begin
    q = r_qx;  // Use an always block for reg assignment
end

// Assign value to cx
assign cx = r_c & {14{rr_e}}; // Make sure to extend rr_e to 14 bits

endmodule