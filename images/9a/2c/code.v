module top_module(
  input [n-1:0] db,
  input ptype,
  output pbit,
  output error
);parameter n = 8; // number of data bits

// Parity generation function
function [0:0] generate_parity;
  input [n-1:0] data_bits;
  input parity_type;
  begin
    if (parity_type == 0) begin // even parity
      generate_parity = ^data_bits;
    end else begin // odd parity
      generate_parity = ^~data_bits;
    end
  end
endfunction

// Parity checking function
function [0:0] check_parity;
  input [n-1:0] data_bits;
  input parity_type;
  begin
    if (parity_type == 0) begin // even parity
      check_parity = ^data_bits;
    end else begin // odd parity
      check_parity = ^~data_bits;
    end
  end
endfunction

// Generate parity bit
assign pbit = generate_parity(db, ptype);

// Check for errors
assign error = check_parity(db, ptype);

endmodule