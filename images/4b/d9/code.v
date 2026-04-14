module top_module(raygroup, raygroupwe, raygroupid, enablenear, rgData, rgAddr, rgWE, rgAddrValid, rgDone, raydata, rayaddr, raywe, rgWriteEnable, rgReadData, globalreset, clk);input [1:0] raygroup; 
    input raygroupwe; 
    input [1:0] raygroupid; 
    input enablenear; 
    input [31:0] rgData; 
    input [3:0] rgAddr; 
    input [2:0] rgWE; 
    input rgAddrValid; 
    input rgWriteEnable; 
    input globalreset; 
    input clk; 

    output reg rgDone; 
    output reg [31:0] raydata; 
    output reg [3:0] rayaddr; 
    output reg [2:0] raywe; 
    output reg [31:0] rgReadData; 

    reg [31:0] rgDatal; 
    reg [3:0] rgAddrl; 
    reg [2:0] rgWEl; 
    reg rgAddrValidl; 

    always @(posedge clk or posedge globalreset)
    begin
        if (globalreset == 1'b1)
        begin
            raydata <= 0;
            rayaddr <= 0;
            raywe <= 0;
            rgReadData <= 0;

            rgDone <= 1'b0; 
            rgDatal <= 0;
            rgAddrl <= 0;
            rgWEl <= 0;
            rgAddrValidl <= 1'b0; 
        end
        else
        begin
            rgDatal <= rgData; // Latch interchip signals
            rgAddrl <= rgAddr; // To Meet Timing
            rgWEl <= rgWE; 

            rgAddrValidl <= rgAddrValid; 
            if (rgAddrValidl == 1'b0)
            begin
                rgDone <= 1'b0; 
            end 
            if (raygroupwe == 1'b1)
            begin
                raydata[0] <= enablenear; 
                raydata[31:1] <= 0;
                raywe <= 3'b111; 
                rayaddr <= {raygroupid, raygroup}; 
            end
            else
            begin
                raywe <= 0;
            end
            if (rgWriteEnable == 1'b1)
            begin
                // Here we don't update rgData since it's an input.
                // You might have needed a different internal register to hold rgData value.
                // If you want to do something with rgData, consider defining a reg for that purpose.
            end
            else if (rgAddrValidl == 1'b1 && rgDone == 1'b0)
            begin
                rgReadData <= rgDatal;
                rgDone <= 1'b1;
            end 
        end 
    end 
endmodule