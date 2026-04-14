`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    wire q;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .q(q),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            d = 1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Loading 1 into DFF", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            d = 1;
            @(posedge clk);
            #1;

            d = 0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Loading 0 into DFF after 1", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            d = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Maintain d=1 for multiple cycles", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            d = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            d = 0;
            #1;


            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Changing D while clk is low and checking sampled value", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Complex toggle sequence", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_q;
        input expected_state;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: q=%b, state=%b",
                         q, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, state=%b",
                         expected_q, expected_state);
                $display("  Got:      q=%b, state=%b",
                         q, state);
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
        $dumpvars(0,clk, d, q, state);
    end

endmodule
