`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] left_in;
    reg [63:0] right_in;
    reg select;
    wire [63:0] left_out;
    wire [63:0] right_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .left_in(left_in),
        .right_in(right_in),
        .select(select),
        .left_out(left_out),
        .right_out(right_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select 0 - Direct Path", test_num);
            left_in  = 64'hAAAA_AAAA_AAAA_AAAA;
            right_in = 64'h5555_5555_5555_5555;
            select   = 1'b0;
            #1;

            check_outputs(64'hAAAA_AAAA_AAAA_AAAA, 64'h5555_5555_5555_5555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select 1 - Swapped Path", test_num);
            left_in  = 64'hAAAA_AAAA_AAAA_AAAA;
            right_in = 64'h5555_5555_5555_5555;
            select   = 1'b1;
            #1;

            check_outputs(64'h5555_5555_5555_5555, 64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Zeros and Ones - Select 0", test_num);
            left_in  = 64'h0000_0000_0000_0000;
            right_in = 64'hFFFF_FFFF_FFFF_FFFF;
            select   = 1'b0;
            #1;

            check_outputs(64'h0000_0000_0000_0000, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All Zeros and Ones - Select 1", test_num);
            left_in  = 64'h0000_0000_0000_0000;
            right_in = 64'hFFFF_FFFF_FFFF_FFFF;
            select   = 1'b1;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Random Pattern 1 - Select 0", test_num);
            left_in  = 64'h1234_5678_9ABC_DEF0;
            right_in = 64'hFEDC_BA98_7654_3210;
            select   = 1'b0;
            #1;

            check_outputs(64'h1234_5678_9ABC_DEF0, 64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Random Pattern 1 - Select 1", test_num);
            left_in  = 64'h1234_5678_9ABC_DEF0;
            right_in = 64'hFEDC_BA98_7654_3210;
            select   = 1'b1;
            #1;

            check_outputs(64'hFEDC_BA98_7654_3210, 64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Walking Bit Pattern - Select 0", test_num);
            left_in  = 64'h8000_0000_0000_0000;
            right_in = 64'h0000_0000_0000_0001;
            select   = 1'b0;
            #1;

            check_outputs(64'h8000_0000_0000_0000, 64'h0000_0000_0000_0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Walking Bit Pattern - Select 1", test_num);
            left_in  = 64'h8000_0000_0000_0000;
            right_in = 64'h0000_0000_0000_0001;
            select   = 1'b1;
            #1;

            check_outputs(64'h0000_0000_0000_0001, 64'h8000_0000_0000_0000);
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
        testcase008();
        
        
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
        input [63:0] expected_left_out;
        input [63:0] expected_right_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_left_out === (expected_left_out ^ left_out ^ expected_left_out) &&
                expected_right_out === (expected_right_out ^ right_out ^ expected_right_out)) begin
                $display("PASS");
                $display("  Outputs: left_out=%h, right_out=%h",
                         left_out, right_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_out=%h, right_out=%h",
                         expected_left_out, expected_right_out);
                $display("  Got:      left_out=%h, right_out=%h",
                         left_out, right_out);
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
