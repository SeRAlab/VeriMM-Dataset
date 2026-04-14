module top_module(
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] EX_rs,
    input [4:0] EX_rt,
    input [4:0] MEM_rt,
    input MEM_ramwe,
    input MEM_regwe,
    input WB_regwe,
    input [4:0] MEM_RW,
    input [4:0] WB_RW,
    output reg [1:0] ID_forwardA,
    output reg [1:0] ID_forwardB,
    output reg [1:0] EX_forwardA,
    output reg [1:0] EX_forwardB,
    output MEM_forward
);always @ ( * ) begin
        if ((ID_rs != 0) && (ID_rs == MEM_RW) && MEM_regwe) begin
            ID_forwardA <= 2'b10;    
        end else if ((ID_rs != 0) && (ID_rs == WB_RW) && WB_regwe) begin
            ID_forwardA <= 2'b01;    
        end else begin
            ID_forwardA <= 2'b00;    
        end
    end
        

    always @ ( * ) begin
        if ((ID_rt != 0) && (ID_rt == MEM_RW) && MEM_regwe) begin
            ID_forwardB <= 2'b10;    
        end else if ((ID_rt != 0) && (ID_rt == WB_RW) && WB_regwe) begin
            ID_forwardB <= 2'b01;    
        end else begin
            ID_forwardB <= 2'b00;    
        end
    end

    
    
    
    
    
    always @ ( * ) begin
        if ((EX_rs != 0) && (EX_rs == MEM_RW) && MEM_regwe) begin
            EX_forwardA <= 2'b10;    
        end else if ((EX_rs != 0) && (EX_rs == WB_RW) && WB_regwe) begin
            EX_forwardA <= 2'b01;    
        end else begin
            EX_forwardA <= 2'b00;    
        end
    end

    always @ ( * ) begin
        if ((EX_rt != 0) && (EX_rt == MEM_RW) && MEM_regwe) begin
            EX_forwardB <= 2'b10;    
        end else if ((EX_rt != 0) && (EX_rt == WB_RW) && WB_regwe) begin
            EX_forwardB <= 2'b01;    
        end else begin
            EX_forwardB <= 2'b00;    
        end
    end

    
    
    assign MEM_forward = (WB_regwe && MEM_ramwe && MEM_rt != 0 && MEM_rt == WB_RW);

endmodule