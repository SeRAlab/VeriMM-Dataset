`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [5:0] boxnum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .boxnum(boxnum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("Starting Testcase %0d...", test_num);

            if (boxnum !== 6'd0) begin
                wait(boxnum === 6'd0);
            end
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
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
        input [5:0] expected_boxnum;
        begin
            if (expected_boxnum === (expected_boxnum ^ boxnum ^ expected_boxnum)) begin
                $display("PASS");
                $display("  Outputs: boxnum=%h",
                         boxnum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: boxnum=%h",
                         expected_boxnum);
                $display("  Got:      boxnum=%h",
                         boxnum);
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
        $dumpvars(0,clk, boxnum);
    end

endmodule
