`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] key_code;
    wire [12:0] slow_rate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key_code(key_code),
        .slow_rate(slow_rate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            key_code = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Key Code 0", test_num);
            reset_dut();
            key_code = 5'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Key Code 1", test_num);
            reset_dut();
            key_code = 5'd1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'hXXXX);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Key Code 15", test_num);
            reset_dut();
            key_code = 5'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'hXXXX);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Key Code 25", test_num);
            reset_dut();
            key_code = 5'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(13'hXXXX);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Key Code 31", test_num);
            reset_dut();
            key_code = 5'd31;
            @(posedge clk);
            #2;

            #1;


            check_outputs(13'd1909);
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
        input [12:0] expected_slow_rate;
        begin
            if (expected_slow_rate === (expected_slow_rate ^ slow_rate ^ expected_slow_rate)) begin
                $display("PASS");
                $display("  Outputs: slow_rate=%h",
                         slow_rate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slow_rate=%h",
                         expected_slow_rate);
                $display("  Got:      slow_rate=%h",
                         slow_rate);
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
        $dumpvars(0,clk, key_code, slow_rate);
    end

endmodule
