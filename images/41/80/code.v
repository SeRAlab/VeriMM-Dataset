module top_module(output reg full, output reg [2:0]wr_addr,output reg [3:0]wr_ptr, 
input wr_en,wr_rst,wr_clk, 
input [3:0]wq2_rptr);reg [3:0]wr_count;




always @ (posedge wr_clk,posedge wr_rst)
begin
    if(wr_rst)
    begin
        full<=0;
        wr_addr<=0;
        wr_ptr<=0;
        wr_count<=0;
    end
    else 
    begin
        if((wr_ptr[3]!=wq2_rptr[3])&&(wr_ptr[2]!=wq2_rptr[2])&&(wr_ptr[1:0]==wq2_rptr[1:0]))
        begin
            full<=1;
        end
        else
        begin
            full<=0;
            wr_count<=wr_count + (wr_en & ~full);
            wr_ptr <= {wr_count[3],wr_count[3:1]^wr_count[2:0]};
            wr_addr <= wr_count[2:0];
        end
        
    end
end
endmodule