`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Up 5 steps (0 to 5)", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Up Wrap-around (0 to 15 to 0)", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 16; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Down Underflow (0 to 15)", test_num);
            reset_dut();
            up = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count Down 10 steps (0 to 6)", test_num);
            reset_dut();
            up = 0;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Up and Down (Up 10, Down 3)", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);
            up = 0;
            for (i = 0; i < 3; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority (Up=1 while Reset=1)", test_num);
            reset_dut();

            reset = 1;
            up = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
            reset = 0;
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, up, q);
    end

endmodule
