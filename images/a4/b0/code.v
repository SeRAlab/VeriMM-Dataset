module top_module(
  input clk, // Added clock input
  input [n-1:0] req,
  output reg [n-1:0] grant // Changed output to reg type for assignment in always block
);parameter n = 4; // number of devices

reg [n-1:0] grant_reg; // register to store the current grant
reg [n-1:0] counter; // counter to cycle through the devices
wire [n-1:0] req_priority; // wire to store the priority of each request

assign req_priority = req & ~(grant_reg); // correct logic for determining priority of requests

always @(posedge clk) begin
  if (req_priority != 0) begin // if there are requests
    counter <= counter + 1; // increment counter
    grant_reg <= {n{1'b0}}; // reset grant register
    if (req_priority[counter]) begin // if current device has a request
      grant_reg[counter] <= 1'b1; // grant access to current device
    end else begin // if current device does not have a request
      grant_reg <= {n{1'b0}}; // deny access to all devices
    end
  end
end

assign grant = grant_reg; // assign grant signals to output

endmodule