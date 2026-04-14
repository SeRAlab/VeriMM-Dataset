`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] set_val;
    reg sreset;
    reg sset;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .set_val(set_val),
        .sreset(sreset),
        .sset(sset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            sset = 0;
            set_val = 0;
            @(posedge clk);
            #1;
            sreset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Set to 0xA5A", test_num);
            reset_dut();
            set_val = 12'hA5A;
            sset = 1;
            @(posedge clk);
            #1;
            sset = 0;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Incrementing (10 cycles)", test_num);
            reset_dut();

            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incrementing after Set", test_num);
            reset_dut();
            set_val = 12'h100;
            sset = 1;
            @(posedge clk);
            #1;
            sset = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h105);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (sreset vs sset)", test_num);
            reset_dut();
            set_val = 12'hFFF;
            sset = 1;
            sreset = 1;
            @(posedge clk);
            #1;
            sreset = 0;
            sset = 0;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover Check", test_num);
            reset_dut();
            set_val = 12'hFFE;
            sset = 1;
            @(posedge clk);
            #1;
            sset = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Sets in sequence", test_num);
            reset_dut();
            set_val = 12'h123;
            sset = 1;
            @(posedge clk);
            #1;
            set_val = 12'h456;
            sset = 1;
            @(posedge clk);
            #1;
            sset = 0;
            #1;

            check_outputs(12'h456);
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
        input [11:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, set_val, sreset, sset, count);
    end

endmodule
