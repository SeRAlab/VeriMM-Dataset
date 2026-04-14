`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] i_a;
    reg [5:0] i_b;
    wire [10:0] o_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .i_b(i_b),
        .o_r(o_r)
    );
    task testcase001;

    begin
        test_num = 1;
        i_a = 6'd0;
        i_b = 6'd0;
        $display("Test %0d: Zero multiplication (0 * 0)", test_num);
        #1;

        check_outputs(11'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i_a = 6'd63;
        i_b = 6'd0;
        $display("Test %0d: Multiplication by zero (63 * 0)", test_num);
        #1;

        check_outputs(11'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i_a = 6'd1;
        i_b = 6'd45;
        $display("Test %0d: Identity multiplication (1 * 45)", test_num);
        #1;

        check_outputs(11'd45);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i_a = 6'd8;
        i_b = 6'd4;
        $display("Test %0d: Simple power of 2 (8 * 4)", test_num);
        #1;

        check_outputs(11'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i_a = 6'd15;
        i_b = 6'd7;
        $display("Test %0d: Small product (15 * 7)", test_num);
        #1;

        check_outputs(11'd105);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i_a = 6'd31;
        i_b = 6'd31;
        $display("Test %0d: Mid-range product (31 * 31)", test_num);
        #1;

        check_outputs(11'd961);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i_a = 6'd32;
        i_b = 6'd63;
        $display("Test %0d: Near maximum of 11-bit range (32 * 63)", test_num);
        #1;

        check_outputs(11'd2016);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i_a = 6'd63;
        i_b = 6'd63;


        $display("Test %0d: Max input values (63 * 63) - Truncated to 11-bit", test_num);
        #1;

        check_outputs(11'd3969 & 11'h7FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        i_a = 6'd44;
        i_b = 6'd25;
        $display("Test %0d: Arbitrary product (44 * 25)", test_num);
        #1;

        check_outputs(11'd1100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        i_a = 6'd13;
        i_b = 6'd17;
        $display("Test %0d: Prime number multiplication (13 * 17)", test_num);
        #1;

        check_outputs(11'd221);
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
        input [10:0] expected_o_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_r === (expected_o_r ^ o_r ^ expected_o_r)) begin
                $display("PASS");
                $display("  Outputs: o_r=%h",
                         o_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_r=%h",
                         expected_o_r);
                $display("  Got:      o_r=%h",
                         o_r);
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
