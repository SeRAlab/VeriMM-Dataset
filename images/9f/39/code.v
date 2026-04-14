module top_module(
  input [n-1:0] in,
  input clk,
  output [m-1:0] out,
  output flag
);parameter n = 8; // number of input data bits
parameter m = 4; // number of output data bits
parameter k = 4; // number of generator bits
parameter generator = 4'h3; // generator polynomial

reg [n+k-1:0] data;
reg [k-1:0] crc;
reg [m-1:0] out_data;
reg crc_check;

assign out = out_data;
assign flag = crc_check;

function [k-1:0] generate_crc;
  input [n-1:0] data_in;
  input [k-1:0] crc_in;
  input [k-1:0] generator_in;
  reg [n+k-1:0] data_temp;
  reg [k-1:0] crc_temp;
  integer i, j;
  begin
    for (i = 0; i < n; i = i + 1) begin
      data_temp[i] = data_in[i];
    end
    for (i = 0; i < k; i = i + 1) begin
      data_temp[n+i] = crc_in[i];
    end
    for (i = 0; i < n; i = i + 1) begin
      if (data_temp[i] == 1) begin
        for (j = 0; j < k; j = j + 1) begin
          data_temp[i+j] = data_temp[i+j] ^ generator_in[j];
        end
      end
    end
    for (i = 0; i < k; i = i + 1) begin
      crc_temp[i] = data_temp[n+i];
    end
    generate_crc = crc_temp;
  end
endfunction

function [m-1:0] compute_crc;
  input [n+k-1:0] data_in;
  input [k-1:0] generator_in;
  reg [n+k-1:0] data_temp;
  reg [k-1:0] crc_temp;
  integer i, j;
  begin
    for (i = 0; i < n+k; i = i + 1) begin
      data_temp[i] = data_in[i];
    end
    for (i = 0; i < n; i = i + 1) begin
      if (data_temp[i] == 1) begin
        for (j = 0; j < k; j = j + 1) begin
          data_temp[i+j] = data_temp[i+j] ^ generator_in[j];
        end
      end
    end
    for (i = 0; i < k; i = i + 1) begin
      crc_temp[i] = data_temp[n+i];
    end
    compute_crc = crc_temp;
  end
endfunction

always @(posedge clk) begin
  data <= {in, crc};
  crc <= generate_crc(in, crc, generator);
  out_data <= data[n-1:0];
  crc_check <= (compute_crc(data, generator) == 0);
end

endmodule