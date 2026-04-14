`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;


            force dut.count = 2'b00;
            @(negedge clk);
            release dut.count;
            $display("DUT Reset: count = %b", count);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment once (0 -> 1)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
            enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment twice (0 -> 2)", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
            enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment three times (0 -> 3)", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
            enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap around check (0 -> 0 after 4 steps)", test_num);
            reset_dut();
            enable = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
            enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value check (Enable=0)", test_num);
            reset_dut();
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent enable (1 on, 2 off, 1 on)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
            enable = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple wrap arounds (Increment by 6)", test_num);
            reset_dut();
            enable = 1;
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
            enable = 0;
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
        input [1:0] expected_count;
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
        $dumpvars(0,clk, enable, count);
    end

endmodule
