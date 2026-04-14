module priority_encoder_4bit (y1, y0, d3, d2, d1, d0);
   input d3, d2, d1, d0;
   output y1, y0;
   
   reg y1, y0;

always @(*) begin
    if (d3)
    begin
        y1 = 1;
        y0 = 1;
    end
    else if (d2)
    begin
        y1 = 1;
        y0 = 0;
    end
    else if (d1)
    begin
        y1 = 0;
        y0 = 1;
    end
    else if (d0)
    begin
        y1 = 0;
        y0 = 0;
    end
    else
    begin
        y1 = 0;
        y0 = 0;
    end
end //End of always block
    
endmodule