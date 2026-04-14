`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cnt;
    reg res;
    wire [5:0] address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cnt(cnt),
        .res(res),
        .address(address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            res = 1;
            cnt = 0;
            @(posedge clk);
            #1;
            res = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(6'd32);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single increment (32 -> 33)", test_num);
            reset_dut();
            cnt = 1;
            @(posedge clk);
            #1;
            cnt = 0;

            #1;


            check_outputs(6'd33);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count to max value (36)", test_num);
            reset_dut();
            cnt = 1;
            repeat(4) @(posedge clk);
            #1;
            cnt = 0;

            #1;


            check_outputs(6'd36);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap around check (36 -> 32)", test_num);
            reset_dut();
            cnt = 1;
            repeat(5) @(posedge clk);
            #1;
            cnt = 0;

            #1;


            check_outputs(6'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify cnt=0 prevents increment", test_num);
            reset_dut();
            cnt = 1;
            repeat(2) @(posedge clk);
            #1;
            cnt = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd34);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Continuous counting with multiple wraps", test_num);
            reset_dut();
            cnt = 1;

            repeat(11) @(posedge clk);
            #1;
            cnt = 0;

            #1;


            check_outputs(6'd33);
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
        input [5:0] expected_address;
        begin
            if (expected_address === (expected_address ^ address ^ expected_address)) begin
                $display("PASS");
                $display("  Outputs: address=%h",
                         address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h",
                         expected_address);
                $display("  Got:      address=%h",
                         address);
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
        $dumpvars(0,clk, cnt, res, address);
    end

endmodule
