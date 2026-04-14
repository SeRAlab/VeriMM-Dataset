module top_module(
      input [31:0]F2Dir,
      D2EXir,
      EX2Mir,
      M2WBir,
      input [4:0]wsex,wsmem,wswb,rs,rt,
      input weex,wemem,wewb,re1,re2,
      output reg [1:0]mux3sel,mux4sel
      
  );always@ * begin
    if(    ((rs==wsex) && re1 && weex )    )begin
        mux3sel = 2'd1;
    end
    else if(   (rs==wsmem) && re1 && wemem   ) begin
        mux3sel = 2'd2;
    end

    else if(   (rs==wswb) && re1 && wewb   ) begin
        mux3sel = 2'd3;
    end
    else begin
        mux3sel = 2'd0;
    end
    
    if(  (rt==wsex) && re2 && weex  )begin
        mux4sel = 2'd1;
    end
    else if(   (rt==wsmem) && re2 && wemem   ) begin
        mux4sel = 2'd2;
    end

    else if(   (rt==wswb) && re2 && wewb   ) begin
        mux4sel = 2'd3;
    end
    else begin
        mux4sel = 2'd0;
    end
    
  end

  endmodule