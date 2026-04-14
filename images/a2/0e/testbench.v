`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ALU_OP;
    reg Mem_Write;
    reg [4:0] RS;
    reg [4:0] RT;
    reg Reset;
    reg [4:0] W_Addr;
    reg Write_Reg;
    reg clk;
    reg [15:0] offset;
    wire [31:0] A;
    wire [31:0] Data_Bus;
    wire OF;
    wire [31:0] Result;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_OP(ALU_OP),
        .Mem_Write(Mem_Write),
        .RS(RS),
        .RT(RT),
        .Reset(Reset),
        .W_Addr(W_Addr),
        .Write_Reg(Write_Reg),
        .clk(clk),
        .offset(offset),
        .A(A),
        .Data_Bus(Data_Bus),
        .OF(OF),
        .Result(Result),
        .ZF(ZF)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            ALU_OP = 0;
            Mem_Write = 0;
            RS = 0;
            RT = 0;
            W_Addr = 0;
            Write_Reg = 0;
            offset = 0;
            @(posedge clk);
            #2 Reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Register Write and Read", test_num);
            reset_dut();



            RS = 0;
            offset = 16'h000A;
            ALU_OP = 3'b000;
            W_Addr = 5'd1;
            Write_Reg = 1;
            @(posedge clk);


            #1;
            Write_Reg = 0;
            RS = 5'd1;
            RT = 5'd0;
            #1;

            #1;


            check_outputs(32'h0000_000A, 32'h0, 1'b0, 32'h0000_000A, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition Operation", test_num);
            reset_dut();


            RS = 0; offset = 16'd10; ALU_OP = 0; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);

            RS = 0; offset = 16'd20; ALU_OP = 0; W_Addr = 2; Write_Reg = 1;
            @(posedge clk);


            #1;
            Write_Reg = 0;
            RS = 5'd1;
            RT = 5'd2;
            ALU_OP = 3'b000;
            #1;
            #1;

            check_outputs(32'd10, 32'd20, 1'b0, 32'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Subtraction and Zero Flag", test_num);
            reset_dut();


            RS = 0; offset = 16'd20; ALU_OP = 0; W_Addr = 2; Write_Reg = 1;
            @(posedge clk);

            #1;
            Write_Reg = 0;
            RS = 5'd2;
            RT = 5'd2;
            ALU_OP = 3'b001;
            #1;
            #1;

            check_outputs(32'd20, 32'd20, 1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitwise XOR", test_num);
            reset_dut();


            RS = 0; offset = 16'hF0F0; ALU_OP = 0; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);

            RS = 0; offset = 16'hFFFF; ALU_OP = 0; W_Addr = 2; Write_Reg = 1;
            @(posedge clk);

            #1;
            Write_Reg = 0;
            RS = 1; RT = 2;
            ALU_OP = 3'b100;
            #1;
            #1;

            check_outputs(32'h0000F0F0, 32'h0000FFFF, 1'b0, 32'h00000F0F, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Detection", test_num);
            reset_dut();








            RS = 0; offset = 16'h7FFF; ALU_OP = 0; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);

            RS = 1; offset = 16'd16; ALU_OP = 3'b101; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);

            RS = 1; offset = 16'hFFFF; ALU_OP = 3'b011; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);


            #1;
            Write_Reg = 0;
            RS = 1;
            RT = 0;
            offset = 16'd1;
            ALU_OP = 3'b000;
            #1;

            #1;


            check_outputs(32'h7FFFFFFF, 32'h0, 1'b1, 32'h80000000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Memory Write Verification", test_num);
            reset_dut();


            RS = 0; offset = 16'h0100; ALU_OP = 0; W_Addr = 1; Write_Reg = 1;
            @(posedge clk);




            #1;
            Write_Reg = 0;
            RS = 1;
            RT = 2;
            offset = 16'h0004;
            ALU_OP = 0;
            Mem_Write = 1;
            #1;


            if (Result === 32'h104 && Mem_Write === 1) begin
                $display("PASS: Memory Write Signals Correct");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Memory Write Signals Incorrect. Got Result=%h, Mem_Write=%b", Result, Mem_Write);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_A;
        input [31:0] expected_Data_Bus;
        input expected_OF;
        input [31:0] expected_Result;
        input expected_ZF;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_Data_Bus === (expected_Data_Bus ^ Data_Bus ^ expected_Data_Bus) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_Result === (expected_Result ^ Result ^ expected_Result) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: A=%h, Data_Bus=%h, OF=%b, Result=%h, ZF=%b",
                         A, Data_Bus, OF, Result, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, Data_Bus=%h, OF=%b, Result=%h, ZF=%b",
                         expected_A, expected_Data_Bus, expected_OF, expected_Result, expected_ZF);
                $display("  Got:      A=%h, Data_Bus=%h, OF=%b, Result=%h, ZF=%b",
                         A, Data_Bus, OF, Result, ZF);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ALU_OP, Mem_Write, RS, RT, Reset, W_Addr, Write_Reg, clk, offset, A, Data_Bus, OF, Result, ZF);
    end

endmodule
