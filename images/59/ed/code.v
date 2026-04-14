module top_module(
  input [7:0] iTD_DATA,
  input iSwap_CbCr,
  input iSkip,
  input iRST_N,
  input iCLK_27,
  output [9:0] oTV_X,
  output [9:0] oTV_Y,
  output [31:0] oTV_Cont,
  output [15:0] oYCbCr,
  output oDVAL
);reg [23:0] Window;
reg [17:0] Cont;
reg Active_Video;
reg Start;
reg Data_Valid;
reg Pre_Field;
reg Field;
wire SAV;
reg FVAL;
reg [9:0] TV_Y;
reg [31:0] Data_Cont;
reg [7:0] Cb;
reg [7:0] Cr;
reg [15:0] YCbCr;

assign oTV_X = Cont >> 1;
assign oTV_Y = TV_Y;
assign oYCbCr = YCbCr;
assign oDVAL = Data_Valid;
assign SAV = (Window == 24'hFF0000) & (iTD_DATA[4] == 1'b0);
assign oTV_Cont = Data_Cont;

always @(posedge iCLK_27 or negedge iRST_N) begin
  if (!iRST_N) begin
    Active_Video <= 1'b0;
    Start <= 1'b0;
    Data_Valid <= 1'b0;
    Pre_Field <= 1'b0;
    Field <= 1'b0;
    Window <= 24'h0;
    Cont <= 18'h0;
    Cb <= 8'h0;
    Cr <= 8'h0;
    YCbCr <= 16'h0;
    FVAL <= 1'b0;
    TV_Y <= 10'h0;
    Data_Cont <= 32'h0;
  end
  else begin
    Window <= {Window[15:0], iTD_DATA};
    if (SAV) Cont <= 18'h0;
    else if (Cont < 1440) Cont <= Cont + 1'b1;
    if (SAV) Active_Video <= 1'b1;
    else if (Cont == 1440) Active_Video <= 1'b0;
    Pre_Field <= Field;
    if ({Pre_Field, Field} == 2'b10) Start <= 1'b1;
    if (Window == 24'hFF0000) begin
      FVAL <= !iTD_DATA[5];
      Field <= iTD_DATA[6];
    end
    if (iSwap_CbCr) begin
      case (Cont[1:0])
        0: Cb <= iTD_DATA;
        1: YCbCr <= {iTD_DATA, Cr};
        2: Cr <= iTD_DATA;
        3: YCbCr <= {iTD_DATA, Cb};
      endcase
    end
    else begin
      case (Cont[1:0])
        0: Cb <= iTD_DATA;
        1: YCbCr <= {iTD_DATA, Cb};
        2: Cr <= iTD_DATA;
        3: YCbCr <= {iTD_DATA, Cr};
      endcase
    end
    if (Start && FVAL && Active_Video && Cont[0] && !iSkip) Data_Valid <= 1'b1;
    else Data_Valid <= 1'b0;
    if (FVAL && SAV) TV_Y <= TV_Y + 1;
    if (!FVAL) TV_Y <= 0;
    if (!FVAL) Data_Cont <= 0;
    if (Data_Valid) Data_Cont <= Data_Cont + 1'b1;
  end
end

endmodule