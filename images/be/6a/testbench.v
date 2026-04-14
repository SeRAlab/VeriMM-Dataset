`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros");
            din = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All Ones");
            din = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: LSB only");
            din = 8'h01;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: MSB only");
            din = 8'h80;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Alternating bits (55)");
            din = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Alternating bits (AA)");
            din = 8'hAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Nibble high");
            din = 8'hF0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Nibble low");
            din = 8'h0F;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Palindrome pattern");
            din = 8'hC3;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Arbitrary pattern");
            din = 8'hB2;
            #1;

            check_outputs(8'h4D);
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
        input [7:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
