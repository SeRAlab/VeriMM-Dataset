module top_module(
  input clk,
  input rst,
  input [addr_width-1:0] addr,
  input wr_en,
  input [data_width-1:0] wr_data,
  input rd_en,
  output reg [data_width-1:0] rd_data
);parameter data_width = 8; // width of the data bus (in bits)
parameter addr_width = 16; // width of the address bus (in bits)

reg [data_width-1:0] mem[2**addr_width-1:0]; // memory array

// state machine states
localparam IDLE = 2'b00;
localparam READ = 2'b01;
localparam WRITE = 2'b10;

reg [1:0] state = IDLE; // state register

always @(posedge clk) begin
  if (rst) begin
    state <= IDLE; // reset state to IDLE
    rd_data <= 0; // reset rd_data output
  end
  else begin
    case (state)
      IDLE: begin
        if (rd_en) begin
          state <= READ; // transition to READ state
        end
        else if (wr_en) begin
          state <= WRITE; // transition to WRITE state
        end
      end
      READ: begin
        rd_data <= mem[addr]; // read data from memory
        state <= IDLE; // transition back to IDLE state
      end
      WRITE: begin
        mem[addr] <= wr_data; // write data to memory
        state <= IDLE; // transition back to IDLE state
      end
    endcase
  end
end

endmodule