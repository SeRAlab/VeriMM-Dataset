`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg [15:0] D;
    reg LD;
    reg RST;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .LD(LD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LD = 0;
            CE = 0;
            D = 16'h0;
            @(posedge CLK);
            #1 RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data", test_num);
            reset_dut();
            D = 16'hA5A5;
            LD = 1;
            @(posedge CLK);
            #1 LD = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment Counter", test_num);
            reset_dut();

            D = 16'd10;
            LD = 1;
            @(posedge CLK);
            #1 LD = 0;
            CE = 1;
            repeat(5) @(posedge CLK);
            #1 CE = 0;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority over CE", test_num);
            reset_dut();
            D = 16'h1234;
            LD = 1;
            CE = 1;
            @(posedge CLK);
            #1 LD = 0; CE = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Load", test_num);
            reset_dut();
            LD = 1;
            D = 16'hFFFF;
            RST = 1;
            @(posedge CLK);
            #1 RST = 0; LD = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Value (CE=0, LD=0)", test_num);
            reset_dut();
            D = 16'h7777;
            LD = 1;
            @(posedge CLK);
            #1 LD = 0; CE = 0;
            repeat(3) @(posedge CLK);
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Overflow (FFFF -> 0000)", test_num);
            reset_dut();
            D = 16'hFFFF;
            LD = 1;
            @(posedge CLK);
            #1 LD = 0; CE = 1;
            @(posedge CLK);
            #1 CE = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing from 16'hFFFE", test_num);
            reset_dut();
            D = 16'hFFFE;
            LD = 1;
            @(posedge CLK);
            #1 LD = 0; CE = 1;
            @(posedge CLK);
            #1 CE = 0;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CE, CLK, D, LD, RST, Q);
    end

endmodule
