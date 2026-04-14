`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg work;
    wire [11:0] wait_time;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .work(work),
        .wait_time(wait_time)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            work = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 5 cycles of idle time", test_num);
            reset_dut();
            work = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 15 cycles of idle time", test_num);
            reset_dut();
            work = 0;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Pause when work is high", test_num);
            reset_dut();
            work = 0;
            repeat(5) @(posedge clk);
            work = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Resume after pause", test_num);
            reset_dut();
            work = 0;
            repeat(5) @(posedge clk);
            work = 1;
            repeat(5) @(posedge clk);
            work = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Internal counter pause mid-cycle", test_num);
            reset_dut();
            work = 0;
            repeat(2) @(posedge clk);
            work = 1;
            repeat(5) @(posedge clk);
            work = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Accumulating 50 cycles", test_num);
            reset_dut();
            work = 0;
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10);
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
        input [11:0] expected_wait_time;
        begin
            if (expected_wait_time === (expected_wait_time ^ wait_time ^ expected_wait_time)) begin
                $display("PASS");
                $display("  Outputs: wait_time=%h",
                         wait_time);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wait_time=%h",
                         expected_wait_time);
                $display("  Got:      wait_time=%h",
                         wait_time);
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
        $dumpvars(0,clk, reset, work, wait_time);
    end

endmodule
