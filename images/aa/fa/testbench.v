`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg mclk;
    wire bclk;
    wire [7:0] cnt256_n;
    wire wclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mclk(mclk),
        .bclk(bclk),
        .cnt256_n(cnt256_n),
        .wclk(wclk)
    );

    // Clock generation (10ns period)
    initial begin
        mclk = 0;
        forever #5 mclk = ~mclk;
    end

        task reset_dut;

        begin

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b0, 8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            repeat(3) @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            repeat(124) @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b1, 8'h80, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b0, 8'h7F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            repeat(127) @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            repeat(2) @(posedge mclk);
            #1;
            #1;

            check_outputs(1'b0, 8'hFE, 1'b1);
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
        input expected_bclk;
        input [7:0] expected_cnt256_n;
        input expected_wclk;
        begin
            if (expected_bclk === (expected_bclk ^ bclk ^ expected_bclk) &&
                expected_cnt256_n === (expected_cnt256_n ^ cnt256_n ^ expected_cnt256_n) &&
                expected_wclk === (expected_wclk ^ wclk ^ expected_wclk)) begin
                $display("PASS");
                $display("  Outputs: bclk=%b, cnt256_n=%h, wclk=%b",
                         bclk, cnt256_n, wclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bclk=%b, cnt256_n=%h, wclk=%b",
                         expected_bclk, expected_cnt256_n, expected_wclk);
                $display("  Got:      bclk=%b, cnt256_n=%h, wclk=%b",
                         bclk, cnt256_n, wclk);
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
        $dumpvars(0,mclk, bclk, cnt256_n, wclk);
    end

endmodule
