`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BorrowIn;
    reg Xin;
    reg Yin;
    wire BorrowOut;
    wire Diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BorrowIn(BorrowIn),
        .Xin(Xin),
        .Yin(Yin),
        .BorrowOut(BorrowOut),
        .Diff(Diff)
    );
    task testcase001;

    begin
        test_num = 1;
        Xin = 1'b0; Yin = 1'b0; BorrowIn = 1'b0;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Xin = 1'b0; Yin = 1'b0; BorrowIn = 1'b1;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Xin = 1'b0; Yin = 1'b1; BorrowIn = 1'b0;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Xin = 1'b0; Yin = 1'b1; BorrowIn = 1'b1;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Xin = 1'b1; Yin = 1'b0; BorrowIn = 1'b0;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Xin = 1'b1; Yin = 1'b0; BorrowIn = 1'b1;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Xin = 1'b1; Yin = 1'b1; BorrowIn = 1'b0;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Xin = 1'b1; Yin = 1'b1; BorrowIn = 1'b1;
        $display("Test %0d: Xin=%b, Yin=%b, Bin=%b", test_num, Xin, Yin, BorrowIn);
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_BorrowOut;
        input expected_Diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BorrowOut === (expected_BorrowOut ^ BorrowOut ^ expected_BorrowOut) &&
                expected_Diff === (expected_Diff ^ Diff ^ expected_Diff)) begin
                $display("PASS");
                $display("  Outputs: BorrowOut=%b, Diff=%b",
                         BorrowOut, Diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BorrowOut=%b, Diff=%b",
                         expected_BorrowOut, expected_Diff);
                $display("  Got:      BorrowOut=%b, Diff=%b",
                         BorrowOut, Diff);
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
