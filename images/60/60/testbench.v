`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .seg(seg)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input x = 0");
            test_num = 1;
            x = 4'd0;
            #1;

            check_outputs(7'b1111110);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input x = 1");
            test_num = 2;
            x = 4'd1;
            #1;

            check_outputs(7'b0110000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input x = 2");
            test_num = 3;
            x = 4'd2;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input x = 3");
            test_num = 4;
            x = 4'd3;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input x = 4");
            test_num = 5;
            x = 4'd4;
            #1;

            check_outputs(7'b0110011);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Input x = 5");
            test_num = 6;
            x = 4'd5;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Input x = 6");
            test_num = 7;
            x = 4'd6;
            #1;

            check_outputs(7'b1011111);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Input x = 7");
            test_num = 8;
            x = 4'd7;
            #1;

            check_outputs(7'b1110000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Input x = 8");
            test_num = 9;
            x = 4'd8;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Input x = 9");
            test_num = 10;
            x = 4'd9;
            #1;

            check_outputs(7'b1111011);
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
