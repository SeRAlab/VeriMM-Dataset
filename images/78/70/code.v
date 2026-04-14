module top_module(A, Y);parameter WIDTH = 0;
  parameter LUT = 0;

  (* force_downto *)
  input [WIDTH-1:0] A;
  output Y;

  generate
    if (WIDTH == 1) begin
      AL_MAP_LUT1 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]));
    end else
    if (WIDTH == 2) begin
      AL_MAP_LUT2 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]), .b(A[1]));
    end else
    if (WIDTH == 3) begin
      AL_MAP_LUT3 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]), .b(A[1]), .c(A[2]));
    end else
    if (WIDTH == 4) begin
      AL_MAP_LUT4 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]), .b(A[1]), .c(A[2]), .d(A[3]));
    end else
    if (WIDTH == 5) begin
      AL_MAP_LUT5 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]), .b(A[1]), .c(A[2]), .d(A[3]), .e(A[4]));
    end else
    if (WIDTH == 6) begin
      AL_MAP_LUT6 #(.EQN(""),.INIT(LUT)) _TECHMAP_REPLACE_ (.o(Y), .a(A[0]), .b(A[1]), .c(A[2]), .d(A[3]), .e(A[4]), .f(A[5]));
    end else begin
      wire _TECHMAP_FAIL_ = 1;
    end
  endgenerate
endmodule