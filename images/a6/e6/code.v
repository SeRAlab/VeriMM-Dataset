module top_module(
  input [n-1:0] addr,
  input we,
  input [m-1:0] data,
  output mem_we,
  output mem_re,
  output [m-1:0] mem_data
);parameter n = 8; // number of address signals
parameter m = 32; // number of data signals

reg [n-1:0] state;
reg [m-1:0] mem_data_reg;
reg mem_we_reg;
reg mem_re_reg;

always @(*) begin
  case(state)
    0: begin // idle state
      mem_we_reg = 0;
      mem_re_reg = 0;
      if (we) begin
        state = 1; // write state
      end else begin
        state = 2; // read state
      end
    end
    1: begin // write state
      mem_we_reg = 1;
      mem_re_reg = 0;
      mem_data_reg = data;
      state = 0; // return to idle state
    end
    2: begin // read state
      mem_we_reg = 0;
      mem_re_reg = 1;
      state = 3; // wait for memory read
    end
    3: begin // wait for memory read
      mem_we_reg = 0;
      mem_re_reg = 0;
      mem_data_reg = mem_data;
      state = 0; // return to idle state
    end
  endcase
end

assign mem_we = mem_we_reg;
assign mem_re = mem_re_reg;
assign mem_data = mem_data_reg;

endmodule