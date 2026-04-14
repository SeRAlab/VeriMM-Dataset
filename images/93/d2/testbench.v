`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [3:0] an;
    wire dp;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .an(an),
        .dp(dp),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 4'b0000;
        #1;

        check_outputs(4'b0000, 1'b0, 7'b1000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 4'b0001;
        #1;

        check_outputs(4'b0001, 1'b0, 7'b1111001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 4'b0011;
        #1;

        check_outputs(4'b0010, 1'b0, 7'b0110000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 4'b0100;
        #1;

        check_outputs(4'b0100, 1'b0, 7'b0011001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 4'b0111;
        #1;

        check_outputs(4'b0100, 1'b0, 7'b1111000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 4'b1000;
        #1;

        check_outputs(4'b1000, 1'b1, 7'b0000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 4'b1001;
        #1;

        check_outputs(4'b1000, 1'b1, 7'b0010000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 4'b1010;
        #1;

        check_outputs(4'b1000, 1'b1, 7'b0001000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 4'b1111;
        #1;

        check_outputs(4'b1000, 1'b1, 7'b0001110);
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
        input [3:0] expected_an;
        input expected_dp;
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, dp=%b, seg=%h",
                         an, dp, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, dp=%b, seg=%h",
                         expected_an, expected_dp, expected_seg);
                $display("  Got:      an=%h, dp=%b, seg=%h",
                         an, dp, seg);
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
