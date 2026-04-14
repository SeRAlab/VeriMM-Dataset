`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] BIN;
    wire [3:0] BCD0;
    wire [3:0] BCD1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .BCD0(BCD0),
        .BCD1(BCD1)
    );
    task testcase001;

    begin
        test_num = 1;
        BIN = 5'd0;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        BIN = 5'd7;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd7, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        BIN = 5'd9;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd9, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        BIN = 5'd10;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        BIN = 5'd18;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd8, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        BIN = 5'd20;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        BIN = 5'd25;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd5, 4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        BIN = 5'd30;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        BIN = 5'd31;
        $display("Test %0d: BIN = %0d", test_num, BIN);
        #1;

        check_outputs(4'd1, 4'd3);
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
        input [3:0] expected_BCD0;
        input [3:0] expected_BCD1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD0 === (expected_BCD0 ^ BCD0 ^ expected_BCD0) &&
                expected_BCD1 === (expected_BCD1 ^ BCD1 ^ expected_BCD1)) begin
                $display("PASS");
                $display("  Outputs: BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD0=%h, BCD1=%h",
                         expected_BCD0, expected_BCD1);
                $display("  Got:      BCD0=%h, BCD1=%h",
                         BCD0, BCD1);
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
