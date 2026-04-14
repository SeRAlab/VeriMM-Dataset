module top_module(  input clk, btn,
                    output outedge );reg  btn_d1, btn_d2, btn_d3;


always @(posedge clk)
begin
    btn_d1 <= btn;
    btn_d2 <= btn_d1;
    btn_d3 <= btn_d2;
end


assign outedge = btn_d2 & ~btn_d3;

endmodule