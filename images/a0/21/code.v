module top_module(pulse, reset, clk, clk_1, work, mileage, number_of_halfkm);input pulse, reset, clk, clk_1;
output work;
output [11:0] mileage, number_of_halfkm;

reg work;
reg [11:0] mileage, number_of_halfkm;

reg [7:0] ib;
reg [11:0] sample;
reg flag;

always @ (posedge clk, negedge reset)
begin
    if(!reset)
    begin
        ib <= 0;
        mileage <= 0;
        sample <= 0;
        number_of_halfkm <= 0;
    end
    else
    begin
        if(pulse == 0)  
        begin
            sample <= sample +1;
            if (flag == 1 && sample >= 49) 
            begin               
                if (ib >= 1)
                begin
                    mileage <= mileage +1;
                    if(mileage % 5 == 4) 
                        number_of_halfkm <= number_of_halfkm +1;
                        
                    ib <= 0;
                end
                else ib <= ib +1;
                
                flag <= 0; 
            end
        end
        else 
        begin
            sample <= 0;
            flag <= 1;     
        end
    end
end

reg [11:0] count;

always @ (posedge clk_1, negedge flag)  
begin
        if(flag == 0)
        begin
            work <= 1;
            count <= 0;
        end
        else
        begin
            if (count >= 4) work <= 0;
            else    count <= count +1;
        end
end 

endmodule