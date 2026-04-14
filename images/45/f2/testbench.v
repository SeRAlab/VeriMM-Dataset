`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [68:0] rcn_in;
    reg rst;
    wire filtered;
    wire [68:0] rcn_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rcn_in(rcn_in),
        .rst(rst),
        .filtered(filtered),
        .rcn_out(rcn_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rcn_in = 69'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 69'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Pass-Through", test_num);
            reset_dut();

            rcn_in = {13'h1FFF, 22'h123456, 34'h2AAAAAAAA};
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 69'h1FFF_123456_2AAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Filtering Range 1", test_num);
            reset_dut();

            rcn_in = {13'h0, 22'h0, 34'h123456789};
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 69'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Boundary Address (All 1s)", test_num);
            reset_dut();
            rcn_in = {13'h0, 22'h3FFFFF, 34'h0};
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 69'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data Bit Integrity", test_num);
            reset_dut();

            rcn_in = 69'h155_555555_555555555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 69'h155_555555_555555555);
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
        input expected_filtered;
        input [68:0] expected_rcn_out;
        begin
            if (expected_filtered === (expected_filtered ^ filtered ^ expected_filtered) &&
                expected_rcn_out === (expected_rcn_out ^ rcn_out ^ expected_rcn_out)) begin
                $display("PASS");
                $display("  Outputs: filtered=%b, rcn_out=%h",
                         filtered, rcn_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered=%b, rcn_out=%h",
                         expected_filtered, expected_rcn_out);
                $display("  Got:      filtered=%b, rcn_out=%h",
                         filtered, rcn_out);
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
        $dumpvars(0,clk, rcn_in, rst, filtered, rcn_out);
    end

endmodule
