`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd1;
    reg [3:0] bcd2;
    wire [3:0] in0;
    wire [3:0] in1;
    wire [3:0] in2;
    wire [3:0] in3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd1(bcd1),
        .bcd2(bcd2),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3)
    );
    task testcase001;

    begin
        test_num = 1;
        bcd1 = 4'd0; bcd2 = 4'd0;
        $display("Test %0d: bcd1=0, bcd2=0", test_num);
        #1;

        check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bcd1 = 4'd3; bcd2 = 4'd2;
        $display("Test %0d: bcd1=3, bcd2=2", test_num);
        #1;

        check_outputs(4'd3, 4'd2, 4'd5, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bcd1 = 4'd5; bcd2 = 4'd4;
        $display("Test %0d: bcd1=5, bcd2=4", test_num);
        #1;

        check_outputs(4'd5, 4'd4, 4'd9, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bcd1 = 4'd5; bcd2 = 4'd5;
        $display("Test %0d: bcd1=5, bcd2=5", test_num);
        #1;

        check_outputs(4'd5, 4'd5, 4'd0, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bcd1 = 4'd7; bcd2 = 4'd8;
        $display("Test %0d: bcd1=7, bcd2=8", test_num);
        #1;

        check_outputs(4'd7, 4'd8, 4'd5, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bcd1 = 4'd9; bcd2 = 4'd9;
        $display("Test %0d: bcd1=9, bcd2=9", test_num);
        #1;

        check_outputs(4'd9, 4'd9, 4'd8, 4'd1);
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
        input [3:0] expected_in0;
        input [3:0] expected_in1;
        input [3:0] expected_in2;
        input [3:0] expected_in3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in0 === (expected_in0 ^ in0 ^ expected_in0) &&
                expected_in1 === (expected_in1 ^ in1 ^ expected_in1) &&
                expected_in2 === (expected_in2 ^ in2 ^ expected_in2) &&
                expected_in3 === (expected_in3 ^ in3 ^ expected_in3)) begin
                $display("PASS");
                $display("  Outputs: in0=%h, in1=%h, in2=%h, in3=%h",
                         in0, in1, in2, in3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in0=%h, in1=%h, in2=%h, in3=%h",
                         expected_in0, expected_in1, expected_in2, expected_in3);
                $display("  Got:      in0=%h, in1=%h, in2=%h, in3=%h",
                         in0, in1, in2, in3);
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
