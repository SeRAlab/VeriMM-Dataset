`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BIN;
    wire [3:0] BCD_HI;
    wire [3:0] BCD_LO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BIN(BIN),
        .BCD_HI(BCD_HI),
        .BCD_LO(BCD_LO)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 0", test_num);
            BIN = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 5", test_num);
            BIN = 4'd5;
            #1;

            check_outputs(4'd0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 9", test_num);
            BIN = 4'd9;
            #1;

            check_outputs(4'd0, 4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10", test_num);
            BIN = 4'd10;
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 13", test_num);
            BIN = 4'd13;
            #1;

            check_outputs(4'd1, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 15", test_num);
            BIN = 4'd15;
            #1;

            check_outputs(4'd1, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 1", test_num);
            BIN = 4'd1;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 11", test_num);
            BIN = 4'd11;
            #1;

            check_outputs(4'd1, 4'd1);
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
        input [3:0] expected_BCD_HI;
        input [3:0] expected_BCD_LO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD_HI === (expected_BCD_HI ^ BCD_HI ^ expected_BCD_HI) &&
                expected_BCD_LO === (expected_BCD_LO ^ BCD_LO ^ expected_BCD_LO)) begin
                $display("PASS");
                $display("  Outputs: BCD_HI=%h, BCD_LO=%h",
                         BCD_HI, BCD_LO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_HI=%h, BCD_LO=%h",
                         expected_BCD_HI, expected_BCD_LO);
                $display("  Got:      BCD_HI=%h, BCD_LO=%h",
                         BCD_HI, BCD_LO);
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
