module top_module(
  input [n-1:0] data,
  input ctrl,
  output p,
  output status
);parameter n = 8; // number of data bits

reg parity_bit;
reg [n-1:0] data_with_parity;
wire [n:0] ones_count;
wire even_parity;
wire odd_parity;

// Generate parity bit
assign ones_count = {1'b0, data} + {data, 1'b0};
assign even_parity = (ones_count % 2 == 0);
assign odd_parity = (ones_count % 2 == 1);

always @(*) begin
  if (ctrl == 0) begin
    parity_bit = even_parity;
  end else begin
    parity_bit = odd_parity;
  end
end

// Add parity bit to data
assign data_with_parity = {data, parity_bit};

// Check parity bit at receiver
assign ones_count = {1'b0, data_with_parity} + {data_with_parity, 1'b0};
assign status = (ctrl == 0 && ones_count % 2 == 1) || (ctrl == 1 && ones_count % 2 == 0);

assign p = parity_bit;

endmodule