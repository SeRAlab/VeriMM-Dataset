module top_module(output Q, input P);parameter IO_PAD  = "";
  parameter IO_LOC  = "";
  parameter IO_TYPE = "";

  generate 
    if (IO_TYPE == "SDIOMUX") begin

      SDIOMUX_CELL _TECHMAP_REPLACE_ (
        .I_PAD_$inp(P),
        .I_DAT(Q),
        .I_EN (1'b1),
        .O_PAD_$out(),
        .O_DAT(),
        .O_EN (1'b1)
      );

    end else if (IO_TYPE == "BIDIR") begin // Added condition for BIDIR case

      BIDIR_CELL # (
        .ESEL     (1'b1),
        .OSEL     (1'b1),
        .FIXHOLD  (1'b0),
        .WPD      (1'b0),
        .DS       (1'b0)
      ) _TECHMAP_REPLACE_ (
        .I_PAD_$inp(P),
        .I_DAT(Q),
        .I_EN (1'b1),
        .O_PAD_$out(),
        .O_DAT(),
        .O_EN (1'b0)
      );

    end else begin
      // Optional: Handle other IO types or provide a fallback.
      // $display("Unsupported IO_TYPE: %s", IO_TYPE);
    end 
  endgenerate

endmodule