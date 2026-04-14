`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] bin_val;
    wire [3:0] bcd0;
    wire [3:0] bcd1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_val(bin_val),
        .bcd0(bcd0),
        .bcd1(bcd1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Binary value 0", test_num);
        bin_val = 6'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Binary value 5", test_num);
        bin_val = 6'd5;
        #1;

        check_outputs(4'd0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Binary value 9", test_num);
        bin_val = 6'd9;
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Binary value 10", test_num);
        bin_val = 6'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Binary value 16 (hex threshold)", test_num);
        bin_val = 6'd16;
        #1;

        check_outputs(4'd1, 4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Binary value 29", test_num);
        bin_val = 6'd29;
        #1;

        check_outputs(4'd2, 4'd9);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Binary value 30", test_num);
        bin_val = 6'd30;
        #1;

        check_outputs(4'd3, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Binary value 48", test_num);
        bin_val = 6'd48;
        #1;

        check_outputs(4'd4, 4'd8);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Binary value 55", test_num);
        bin_val = 6'd55;
        #1;

        check_outputs(4'd5, 4'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Binary value 63 (maximum)", test_num);
        bin_val = 6'd63;
        #1;

        check_outputs(4'd6, 4'd3);
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
        input [3:0] expected_bcd0;
        input [3:0] expected_bcd1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd0 === (expected_bcd0 ^ bcd0 ^ expected_bcd0) &&
                expected_bcd1 === (expected_bcd1 ^ bcd1 ^ expected_bcd1)) begin
                $display("PASS");
                $display("  Outputs: bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd0=%h, bcd1=%h",
                         expected_bcd0, expected_bcd1);
                $display("  Got:      bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
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
