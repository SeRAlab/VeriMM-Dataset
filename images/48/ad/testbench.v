`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [7:0] out_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .out_sum(out_sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All zeros", test_num);
        in = 16'h0000;
        #1;

        check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: All ones (Check sum truncation)", test_num);
        in = 16'hFFFF;

        #1;


        check_outputs(8'hFF, 8'hFF, 8'hFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: 0x1234", test_num);
        in = 16'h1234;
        #1;

        check_outputs(8'h12, 8'h34, 8'h46);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: FF + 01 rollover", test_num);
        in = 16'hFF01;

        #1;


        check_outputs(8'hFF, 8'h01, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: MSB set (0x8080)", test_num);
        in = 16'h8080;

        #1;


        check_outputs(8'h80, 8'h80, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Alternating bits (0x55AA)", test_num);
        in = 16'h55AA;

        #1;


        check_outputs(8'h55, 8'hAA, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Max sum no rollover (0x7F80)", test_num);
        in = 16'h7F80;

        #1;


        check_outputs(8'h7F, 8'h80, 8'hFF);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [7:0] expected_out_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_out_sum === (expected_out_sum ^ out_sum ^ expected_out_sum)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h, out_sum=%h",
                         out_hi, out_lo, out_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h, out_sum=%h",
                         expected_out_hi, expected_out_lo, expected_out_sum);
                $display("  Got:      out_hi=%h, out_lo=%h, out_sum=%h",
                         out_hi, out_lo, out_sum);
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

endmodule
