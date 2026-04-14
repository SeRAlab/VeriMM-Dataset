`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dat_i;
    wire [6:0] seg_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dat_i(dat_i),
        .seg_o(seg_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 0 (4'h0)", test_num);
        dat_i = 4'h0;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 1 (4'h1)", test_num);
        dat_i = 4'h1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 2 (4'h2)", test_num);
        dat_i = 4'h2;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 3 (4'h3)", test_num);
        dat_i = 4'h3;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 4 (4'h4)", test_num);
        dat_i = 4'h4;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 5 (4'h5)", test_num);
        dat_i = 4'h5;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 7 (4'h7)", test_num);
        dat_i = 4'h7;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 8 (4'h8)", test_num);
        dat_i = 4'h8;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input Digit 9 (4'h9)", test_num);
        dat_i = 4'h9;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Invalid Input (4'hA)", test_num);
        dat_i = 4'hA;
        #1;

        check_outputs(7'h7E);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Invalid Input (4'hF)", test_num);
        dat_i = 4'hF;
        #1;

        check_outputs(7'h7E);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [6:0] expected_seg_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_o === (expected_seg_o ^ seg_o ^ expected_seg_o)) begin
                $display("PASS");
                $display("  Outputs: seg_o=%h",
                         seg_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_o=%h",
                         expected_seg_o);
                $display("  Got:      seg_o=%h",
                         seg_o);
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
