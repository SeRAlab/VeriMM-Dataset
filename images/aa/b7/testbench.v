`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seven_seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .seven_seg(seven_seg)
    );
    task testcase000;

        begin
            bcd = 4'd0;
            $display("Test Case 000: BCD = 0");
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase001;

        begin
            bcd = 4'd1;
            $display("Test Case 001: BCD = 1");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase002;

        begin
            bcd = 4'd2;
            $display("Test Case 002: BCD = 2");
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase003;

        begin
            bcd = 4'd3;
            $display("Test Case 003: BCD = 3");
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase004;

        begin
            bcd = 4'd4;
            $display("Test Case 004: BCD = 4");
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase005;

        begin
            bcd = 4'd5;
            $display("Test Case 005: BCD = 5");
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase006;

        begin
            bcd = 4'd6;
            $display("Test Case 006: BCD = 6");
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase007;

        begin
            bcd = 4'd7;
            $display("Test Case 007: BCD = 7");
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase008;

        begin
            bcd = 4'd8;
            $display("Test Case 008: BCD = 8");
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase009;

        begin
            bcd = 4'd9;
            $display("Test Case 009: BCD = 9");
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase010;

        begin
            bcd = 4'd10;
            $display("Test Case 010: BCD = 10 (Invalid Case)");


            #1;



            check_outputs(7'h00);
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


        testcase000();
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
        input [6:0] expected_seven_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg)) begin
                $display("PASS");
                $display("  Outputs: seven_seg=%h",
                         seven_seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_seg=%h",
                         expected_seven_seg);
                $display("  Got:      seven_seg=%h",
                         seven_seg);
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
