`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .out(out)
    );
    task testcase000;

        begin
            sel = 4'd0;
            $display("Test Case 000: sel = %d", sel);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase001;

        begin
            sel = 4'd1;
            $display("Test Case 001: sel = %d", sel);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            sel = 4'd2;
            $display("Test Case 002: sel = %d", sel);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            sel = 4'd3;
            $display("Test Case 003: sel = %d", sel);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            sel = 4'd4;
            $display("Test Case 004: sel = %d", sel);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            sel = 4'd5;
            $display("Test Case 005: sel = %d", sel);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase006;

        begin
            sel = 4'd6;
            $display("Test Case 006: sel = %d", sel);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            sel = 4'd7;
            $display("Test Case 007: sel = %d", sel);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase008;

        begin
            sel = 4'd8;
            $display("Test Case 008: sel = %d", sel);
            #1;

            check_outputs(8'hf8);
        end
        endtask

    task testcase009;

        begin
            sel = 4'd9;
            $display("Test Case 009: sel = %d", sel);
            #1;

            check_outputs(8'hf9);
        end
        endtask

    task testcase010;

        begin
            sel = 4'd10;
            $display("Test Case 010: sel = %d", sel);
            #1;

            check_outputs(8'hfa);
        end
        endtask

    task testcase011;

        begin
            sel = 4'd11;
            $display("Test Case 011: sel = %d", sel);
            #1;

            check_outputs(8'hfb);
        end
        endtask

    task testcase012;

        begin
            sel = 4'd12;
            $display("Test Case 012: sel = %d", sel);
            #1;

            check_outputs(8'hfc);
        end
        endtask

    task testcase013;

        begin
            sel = 4'd13;
            $display("Test Case 013: sel = %d", sel);
            #1;

            check_outputs(8'hfd);
        end
        endtask

    task testcase014;

        begin
            sel = 4'd14;
            $display("Test Case 014: sel = %d", sel);
            #1;

            check_outputs(8'hfe);
        end
        endtask

    task testcase015;

        begin
            sel = 4'd15;
            $display("Test Case 015: sel = %d", sel);
            #1;

            check_outputs(8'hff);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
