`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] reverseIn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .reverseIn(reverseIn)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros", test_num);
        in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones", test_num);
        in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Alternating bits (AA)", test_num);
        in = 8'hAA;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Alternating bits (55)", test_num);
        in = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Single bit (LSB)", test_num);
        in = 8'h01;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Single bit (MSB)", test_num);
        in = 8'h80;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Nibble swap pattern (F0)", test_num);
        in = 8'hF0;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Bit pattern CC", test_num);
        in = 8'hCC;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Palindrome pattern 99", test_num);
        in = 8'h99;
        #1;

        check_outputs(8'h99);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Complex pattern 96", test_num);
        in = 8'h96;
        #1;

        check_outputs(8'h69);
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
        input [7:0] expected_reverseIn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reverseIn === (expected_reverseIn ^ reverseIn ^ expected_reverseIn)) begin
                $display("PASS");
                $display("  Outputs: reverseIn=%h",
                         reverseIn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reverseIn=%h",
                         expected_reverseIn);
                $display("  Got:      reverseIn=%h",
                         reverseIn);
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
