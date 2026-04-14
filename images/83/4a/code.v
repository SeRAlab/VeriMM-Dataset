module top_module(
    input clk,rst_n,
    output reg [1:0] sel_sig,
    output [2:0] cnt0_out
  );reg [3:0] cnt0;
wire add_cnt0, end_cnt0;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign add_cnt0 = 1;
assign end_cnt0 = add_cnt0 && cnt0== 6 - 1;
assign cnt0_out = cnt0;

always @ ( * ) begin
  case (cnt0)
    0: sel_sig = 0; 
    1: sel_sig = 0;
    2: sel_sig = 1; 
    3: sel_sig = 1;
    4: sel_sig = 2; 
    5: sel_sig = 2;
    default: sel_sig = 0;
  endcase
end

endmodule