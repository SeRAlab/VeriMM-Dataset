module top_module(
  input wire [1:0] address,
  input wire clk,
  input wire [7:0] in_port,
  input wire reset_n,
  output reg [31:0] readdata
);// Internal buffer for storing timecode data
  reg [7:0] buffer [0:255];
  reg [7:0] read_ptr;
  reg [7:0] write_ptr;
  reg [7:0] byte_count;

  // Control signals
  wire [7:0] data_in;
  wire [7:0] read_mux_out;
  wire clk_en;

  // Enable clock only when required
  assign clk_en = (address == 2'b01) || (address == 2'b10);

  // Read data from buffer
  assign read_mux_out = {8 {(address == 2'b10)}} & buffer[read_ptr];

  // Write data to buffer
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      readdata <= 0;
      read_ptr <= 0;
      write_ptr <= 0;
      byte_count <= 0;
    end else if (clk_en) begin
      case (address)
        2'b00: begin // Write to buffer
          buffer[write_ptr] <= data_in;
          write_ptr <= write_ptr + 1;
          byte_count <= byte_count + 1;
        end
        2'b01: begin // Read from buffer
          if (byte_count > 0) begin
            readdata <= {24'b0, buffer[read_ptr]};
            read_ptr <= read_ptr + 1;
            byte_count <= byte_count - 1;
          end
        end
        2'b10: begin // Output current byte
          if (byte_count > 0) begin
            readdata <= {24'b0, read_mux_out};
          end
        end
        2'b11: begin // Clear buffer
          read_ptr <= 0;
          write_ptr <= 0;
          byte_count <= 0;
        end
      endcase
    end
  end

  assign data_in = in_port;

endmodule