`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [15:0] inter;
    reg ld;
    wire [15:0] a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .inter(inter),
        .ld(ld),
        .a(a)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld = 0;
            in = 16'h0000;
            inter = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'hA5A5;
            inter = 16'h5A5A;
            ld = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Load 'in' (ld=1)", test_num);
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h1234;
            inter = 16'hBEEF;
            ld = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Load 'inter' (ld=0)", test_num);
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'hFFFF;
            inter = 16'h0000;
            ld = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Load 'in' (All 1s)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'h0000;
            inter = 16'hFFFF;
            ld = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Load 'inter' (All 1s)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            in = 16'hFFFF;
            ld = 1;
            @(posedge clk);
            #1;

            in = 16'h0000;
            ld = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Load 'in' (All 0s)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 16'hCAFE;
            inter = 16'hBABE;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Synchronous switch from ld=1 to ld=0", test_num);
            #1;

            check_outputs(16'hBABE);
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
        input [15:0] expected_a;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a)) begin
                $display("PASS");
                $display("  Outputs: a=%h",
                         a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h",
                         expected_a);
                $display("  Got:      a=%h",
                         a);
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
        $dumpvars(0,clk, in, inter, ld, a);
    end

endmodule
