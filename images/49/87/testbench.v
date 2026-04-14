`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] ParallelIn;
    reg ShiftEn;
    reg ShiftIn;
    reg load;
    wire [3:0] RegContent;
    wire ShiftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .ParallelIn(ParallelIn),
        .ShiftEn(ShiftEn),
        .ShiftIn(ShiftIn),
        .load(load),
        .RegContent(RegContent),
        .ShiftOut(ShiftOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            @(posedge Clk);
            load = 1;
            ParallelIn = 4'b0000;
            ShiftEn = 0;
            ShiftIn = 0;
            @(posedge Clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge Clk);
            load = 1;
            ParallelIn = 4'b1011;
            @(posedge Clk);
            load = 0;
            #1;
            $display("Test %0d: Parallel Load 4'b1011", test_num);
            #1;

            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge Clk);
            load = 1;
            ParallelIn = 4'b1000;
            @(posedge Clk);
            load = 0;

            ShiftEn = 1;
            ShiftIn = 1;
            @(posedge Clk);
            ShiftEn = 0;
            #1;
            $display("Test %0d: Load 1000 and Shift Left once with ShiftIn=1", test_num);

            #1;


            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge Clk);
            ShiftEn = 1;
            ShiftIn = 1;
            repeat(4) @(posedge Clk);
            ShiftEn = 0;
            #1;
            $display("Test %0d: Shift in four 1s serially", test_num);
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge Clk);
            load = 1;
            ParallelIn = 4'b0110;
            @(posedge Clk);
            load = 0;
            ShiftEn = 0;
            repeat(2) @(posedge Clk);
            #1;
            $display("Test %0d: Hold value check (load=0, ShiftEn=0)", test_num);
            #1;

            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge Clk);
            load = 1;
            ShiftEn = 1;
            ParallelIn = 4'b1100;
            ShiftIn = 0;
            @(posedge Clk);
            load = 0;
            ShiftEn = 0;
            #1;
            $display("Test %0d: Priority Check (Load and ShiftEn both active)", test_num);
            #1;

            check_outputs(4'b1100, 1'b1);
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
        input [3:0] expected_RegContent;
        input expected_ShiftOut;
        begin
            if (expected_RegContent === (expected_RegContent ^ RegContent ^ expected_RegContent) &&
                expected_ShiftOut === (expected_ShiftOut ^ ShiftOut ^ expected_ShiftOut)) begin
                $display("PASS");
                $display("  Outputs: RegContent=%h, ShiftOut=%b",
                         RegContent, ShiftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegContent=%h, ShiftOut=%b",
                         expected_RegContent, expected_ShiftOut);
                $display("  Got:      RegContent=%h, ShiftOut=%b",
                         RegContent, ShiftOut);
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
        $dumpvars(0,Clk, ParallelIn, ShiftEn, ShiftIn, load, RegContent, ShiftOut);
    end

endmodule
