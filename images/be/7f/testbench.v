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
            din = 8'h00;
            #10;
            $display("Test Case 001: All Zeros (Input: 00)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            din = 8'hFF;
            #10;
            $display("Test Case 002: All Ones (Input: FF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            din = 8'hAA;
            #10;
            $display("Test Case 003: Alternating bits AA -> 55");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            din = 8'h55;
            #10;
            $display("Test Case 004: Alternating bits 55 -> AA");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            din = 8'hCC;
            #10;
            $display("Test Case 005: Pair-wise uniform CC -> CC");
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            din = 8'h33;
            #10;
            $display("Test Case 006: Pair-wise uniform 33 -> 33");
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            din = 8'h01;
            #10;
            $display("Test Case 007: Bit 0 to Bit 1 swap");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            din = 8'h80;
            #10;
            $display("Test Case 008: Bit 7 to Bit 6 swap");
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            din = 8'h12;


            #10;
            $display("Test Case 009: Complex Pattern 12 -> 21");
            #1;

            check_outputs(8'h21);
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
