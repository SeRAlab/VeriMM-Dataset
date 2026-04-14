module top_module(
    input mask_type,
    input game_type,
    output reg [24:0] out
  );always @* begin
    out = 25'h0000000;
    if (mask_type == 1'h0 && game_type == 1'h0) begin
      out = 25'h0000032;
    end else begin
      if (mask_type == 1'h1 && game_type == 1'h0) begin
        out = 25'h009ab20;
      end else begin
        if (mask_type == 1'h0 && game_type == 1'h1) begin
          out = 25'h18c8996;
        end else begin
          if (mask_type == 1'h1 && game_type == 1'h1) begin
            out = 25'h0d2c49e;
          end
        end
      end
    end
  end
endmodule