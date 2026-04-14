`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] numer;
    wire [2:0] quotient;
    wire [3:0] remain;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .numer(numer),
        .quotient(quotient),
        .remain(remain)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0 (Boundary Min)", test_num);
        numer = 6'd0;
        #1;

        check_outputs(3'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 11 (Quotient 0 boundary)", test_num);
        numer = 6'd11;
        #1;

        check_outputs(3'd0, 4'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 12 (First multiple)", test_num);
        numer = 6'd12;
        #1;

        check_outputs(3'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 23 (Quotient 1 boundary)", test_num);
        numer = 6'd23;
        #1;

        check_outputs(3'd1, 4'd11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 24 (Second multiple)", test_num);
        numer = 6'd24;
        #1;

        check_outputs(3'd2, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 35 (Quotient 2 boundary)", test_num);
        numer = 6'd35;
        #1;

        check_outputs(3'd2, 4'd11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 36 (Third multiple)", test_num);
        numer = 6'd36;
        #1;

        check_outputs(3'd3, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 48 (Fourth multiple)", test_num);
        numer = 6'd48;
        #1;

        check_outputs(3'd4, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 60 (Fifth multiple)", test_num);
        numer = 6'd60;
        #1;

        check_outputs(3'd5, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 63 (Maximum input)", test_num);
        numer = 6'd63;
        #1;

        check_outputs(3'd5, 4'd3);
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
        input [2:0] expected_quotient;
        input [3:0] expected_remain;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remain === (expected_remain ^ remain ^ expected_remain)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remain=%h",
                         quotient, remain);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remain=%h",
                         expected_quotient, expected_remain);
                $display("  Got:      quotient=%h, remain=%h",
                         quotient, remain);
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
