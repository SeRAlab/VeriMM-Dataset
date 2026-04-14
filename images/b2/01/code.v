module top_module(clk, rstp, din, readp, writep, dout, emptyp, fullp);input clk;                //时钟
    input rstp;               //复位
    input[15:0] din;          //16位输入信号
    input readp;              //读指令
    input writep;             //写指令
    
    output reg[15:0] dout;    //16位输出信号
    output reg emptyp;        //空指示信号
    output reg fullp;         //满指示信号
  
    parameter DEPTH = 4;      // FIFO深度为4
  
    reg[15:0] fifo_mem[0:DEPTH-1]; // FIFO存储器
    reg[1:0] count;           //FIFO中的元素数量
    reg[1:0] head;            //写指针
    reg[1:0] tail;            //读指针
  
    always @(posedge clk) begin
        if (rstp) begin
            head <= 2'b00;   // 初始化写指针为0
            tail <= 2'b00;   // 初始化读指针为0
            count <= 2'b00;  // 初始化元素数量为0
            fullp <= 1'b0;   // 初始化满指示信号为0
            emptyp <= 1'b1;  // 初始化空指示信号为1
        end
        else begin
            // 更新写指针
            if (writep && !fullp) begin
                fifo_mem[head] <= din;
                head <= head + 2'b01;
                count <= count + 2'b01;
            end
            // 更新读指针
            if (readp && !emptyp) begin
                dout <= fifo_mem[tail];
                tail <= tail + 2'b01;
                count <= count - 2'b01;
            end
            // 更新满指示信号
            if (count == DEPTH-1) // Changed to DEPTH-1
                fullp <= 1'b1;
            else
                fullp <= 1'b0;
            // 更新空指示信号
            if (count == 0)
                emptyp <= 1'b1;
            else
                emptyp <= 1'b0;
        end
    end
endmodule