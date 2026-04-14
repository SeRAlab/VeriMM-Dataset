module top_module(
  input [7:0] pixelNum,
  input [7:0] objPos,
  input [7:0] objMask,
  input [2:0] objSize,
  output      pixelOn
);wire [7:0]  objIndex;
  wire [8:0]  objByteIndex;
  wire        objMaskOn, objPosOn;
  reg         objSizeOn;
  reg [2:0]   objMaskSel;

  assign objIndex = pixelNum - objPos - 8'd1;
  assign objByteIndex = 9'b1 << (objIndex[7:3]);

  always @* begin
    case (objSize)
      3'd0: objSizeOn = (objByteIndex & 9'b00000001) != 0;
      3'd1: objSizeOn = (objByteIndex & 9'b00000101) != 0;
      3'd2: objSizeOn = (objByteIndex & 9'b00010001) != 0;
      3'd3: objSizeOn = (objByteIndex & 9'b00010101) != 0;
      3'd4: objSizeOn = (objByteIndex & 9'b10000001) != 0;
      3'd5: objSizeOn = (objByteIndex & 9'b00000011) != 0;
      3'd6: objSizeOn = (objByteIndex & 9'b10010001) != 0;
      3'd7: objSizeOn = (objByteIndex & 9'b00001111) != 0;
    endcase
  end

  always @* begin
    case (objSize)
      3'd5: objMaskSel = objIndex[3:1];
      3'd7: objMaskSel = objIndex[4:2];
      default: objMaskSel = objIndex[2:0];
    endcase
  end

  assign objMaskOn = objMask[objMaskSel];

  assign objPosOn = (pixelNum > objPos) && ({1'b0, pixelNum} <= {1'b0, objPos} + 9'd72);

  assign pixelOn = objSizeOn && objMaskOn && objPosOn;

endmodule