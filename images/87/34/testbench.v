`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd(bcd),
        .seg(seg)
    );
    task testcase001;

        begin
            bcd = 4'd0;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            bcd = 4'd1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            bcd = 4'd2;
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            bcd = 4'd3;
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            bcd = 4'd4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            bcd = 4'd5;
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            bcd = 4'd6;
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            bcd = 4'd7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            bcd = 4'd8;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            bcd = 4'd9;
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            bcd = 4'd10;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase012;

        begin
            bcd = 4'd11;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase013;

        begin
            bcd = 4'd12;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase014;

        begin
            bcd = 4'd13;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase015;

        begin
            bcd = 4'd14;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase016;

        begin
            bcd = 4'd15;
            #1;

            check_outputs(7'h3F);
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
