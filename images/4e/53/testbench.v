`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    wire [15:0] out_reverse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .out_reverse(out_reverse)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        a = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        a = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Single Bit MSB", test_num);
        a = 16'h8000;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Single Bit LSB", test_num);
        a = 16'h0001;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits AAAA", test_num);
        a = 16'hAAAA;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits 5555", test_num);
        a = 16'h5555;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Symmetric Palindrome pattern", test_num);
        a = 16'hAA55;
        #1;

        check_outputs(16'hAA55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Pattern 0x1234", test_num);
        a = 16'h1234;
        #1;

        check_outputs(16'h2C48);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Pattern 0xABCD", test_num);
        a = 16'hABCD;
        #1;

        check_outputs(16'hB3D5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Nibble-aligned pattern", test_num);
        a = 16'hF0F0;
        #1;

        check_outputs(16'h0F0F);
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
        input [15:0] expected_out_reverse;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_reverse === (expected_out_reverse ^ out_reverse ^ expected_out_reverse)) begin
                $display("PASS");
                $display("  Outputs: out_reverse=%h",
                         out_reverse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_reverse=%h",
                         expected_out_reverse);
                $display("  Got:      out_reverse=%h",
                         out_reverse);
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
