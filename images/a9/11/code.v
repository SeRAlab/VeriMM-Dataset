module top_module(Clock,D,Qa,Qb,Qc);input Clock;
    input D;
    output reg Qa,Qb,Qc;
        
    always @ (Clock or D)
    if(Clock)
    begin
        Qa <= D;
    end
    
    always @ (posedge Clock)
    begin
        Qb <= D;
    end
    
    always @ (negedge Clock)
    begin
        Qc <= D;
    end
endmodule