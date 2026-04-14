`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] Data_In;
    reg Pop;
    reg Push;
    reg RstN;
    wire [3:0] Data_Out;
    wire Empty;
    wire Full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Data_In(Data_In),
        .Pop(Pop),
        .Push(Push),
        .RstN(RstN),
        .Data_Out(Data_Out),
        .Empty(Empty),
        .Full(Full)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            RstN = 0;
            Push = 0;
            Pop = 0;
            Data_In = 0;
            @(posedge Clk);
            #2 RstN = 1;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'bx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge Clk);
            Data_In = 4'hA;
            Push = 1;
            @(posedge Clk);
            Push = 0;
            @(posedge Clk);
            Pop = 1;
            @(posedge Clk);
            Pop = 0;

            #1;


            check_outputs(4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                Data_In = i;
                Push = 1;
                @(posedge Clk);
            end
            Push = 0;

            #1;


            check_outputs(4'bx, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                Data_In = i;
                Push = 1;
                @(posedge Clk);
            end

            Data_In = 4'hF;
            Push = 1;
            @(posedge Clk);
            Push = 0;

            Pop = 1;
            @(posedge Clk);
            Pop = 0;
            #1;

            check_outputs(4'h8, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            Pop = 1;
            @(posedge Clk);
            Pop = 0;

            #1;


            check_outputs(4'bx, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            Data_In = 4'h3; Push = 1; @(posedge Clk);
            Data_In = 4'h7; Push = 1; @(posedge Clk);
            Push = 0;

            Pop = 1; @(posedge Clk); Pop = 0;

            #1;


            check_outputs(4'h7, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                Data_In = i; Push = 1; @(posedge Clk);
            end
            Push = 0;

            for (i = 0; i < 8; i = i + 1) begin
                Pop = 1; @(posedge Clk);
            end
            Pop = 0;

            #1;


            check_outputs(0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            Data_In = 4'h1; Push = 1; @(posedge Clk);
            Data_In = 4'h2; Push = 1; @(posedge Clk);
            Push = 0; Pop = 1; @(posedge Clk);
            Pop = 0; Data_In = 4'h3; Push = 1; @(posedge Clk);
            Push = 0; Pop = 1; @(posedge Clk);
            Pop = 0;

            Pop = 1; @(posedge Clk); Pop = 0;
            #1;

            check_outputs(4'h1, 1'b1, 1'b0);
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
        testcase008();
        
        
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
        input [3:0] expected_Data_Out;
        input expected_Empty;
        input expected_Full;
        begin
            if (expected_Data_Out === (expected_Data_Out ^ Data_Out ^ expected_Data_Out) &&
                expected_Empty === (expected_Empty ^ Empty ^ expected_Empty) &&
                expected_Full === (expected_Full ^ Full ^ expected_Full)) begin
                $display("PASS");
                $display("  Outputs: Data_Out=%h, Empty=%b, Full=%b",
                         Data_Out, Empty, Full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_Out=%h, Empty=%b, Full=%b",
                         expected_Data_Out, expected_Empty, expected_Full);
                $display("  Got:      Data_Out=%h, Empty=%b, Full=%b",
                         Data_Out, Empty, Full);
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
        $dumpvars(0,Clk, Data_In, Pop, Push, RstN, Data_Out, Empty, Full);
    end

endmodule
