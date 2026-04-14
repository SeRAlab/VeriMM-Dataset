`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin_in;
    wire [6:0] bcd_out_1;
    wire [6:0] bcd_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .bcd_out_1(bcd_out_1),
        .bcd_out_2(bcd_out_2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 0", test_num);
        bin_in = 4'd0;
        #1;

        check_outputs(7'd0, 7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 4", test_num);
        bin_in = 4'd4;
        #1;

        check_outputs(7'd0, 7'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 7", test_num);
        bin_in = 4'd7;
        #1;

        check_outputs(7'd0, 7'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 8", test_num);
        bin_in = 4'd8;
        #1;

        check_outputs(7'd1, 7'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 11", test_num);
        bin_in = 4'd11;
        #1;

        check_outputs(7'd1, 7'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input = 15", test_num);
        bin_in = 4'd15;
        #1;

        check_outputs(7'd1, 7'd7);
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
        input [6:0] expected_bcd_out_1;
        input [6:0] expected_bcd_out_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_out_1 === (expected_bcd_out_1 ^ bcd_out_1 ^ expected_bcd_out_1) &&
                expected_bcd_out_2 === (expected_bcd_out_2 ^ bcd_out_2 ^ expected_bcd_out_2)) begin
                $display("PASS");
                $display("  Outputs: bcd_out_1=%h, bcd_out_2=%h",
                         bcd_out_1, bcd_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out_1=%h, bcd_out_2=%h",
                         expected_bcd_out_1, expected_bcd_out_2);
                $display("  Got:      bcd_out_1=%h, bcd_out_2=%h",
                         bcd_out_1, bcd_out_2);
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
