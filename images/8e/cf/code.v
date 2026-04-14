module top_module(
    
    input               sysclk      ,       
    input               rst_n       ,
    
    output              cmos_pwdn   ,
    output              cmos_reset  ,
    
    output              done        
);localparam      delay_6ms   =   300_000     ;
localparam      delay_2ms   =   100_000     ;
localparam      delay_21ms  =   1_050_000   ;

reg     [20:0]  delay_cnt   ;




always @(posedge sysclk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
        delay_cnt   <=  1'b0    ;
    end else if (delay_cnt == delay_21ms+delay_2ms+delay_6ms-1) begin
        delay_cnt   <=  delay_cnt   ;
    end else begin
        delay_cnt   <=  delay_cnt + 1'b1    ;
    end
end

assign cmos_pwdn    = (delay_cnt < delay_6ms) ? 1'b1 : 1'b0             ;
assign cmos_reset   = (delay_cnt < delay_6ms+delay_2ms) ? 1'b0 : 1'b1   ;
assign done         = (delay_cnt < delay_21ms+delay_2ms+delay_6ms-2) ? 1'b0 : 1'b1;

endmodule