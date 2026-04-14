`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] inp;
    wire [2:0] iout_0;
    wire [2:0] iout_1;
    wire [2:0] iout_2;
    wire [2:0] iout_3;
    wire [2:0] rout_0;
    wire [2:0] rout_1;
    wire [2:0] rout_2;
    wire [2:0] rout_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .iout_0(iout_0),
        .iout_1(iout_1),
        .iout_2(iout_2),
        .iout_3(iout_3),
        .rout_0(rout_0),
        .rout_1(rout_1),
        .rout_2(rout_2),
        .rout_3(rout_3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        inp = 4'b0000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs one", test_num);
        inp = 4'b1111;

        #1;


        check_outputs(0, 0, 0, 0, 2, 2, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 0 only", test_num);
        inp = 4'b0001;

        #1;


        check_outputs(0, 0, 0, 0, 1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 2 only (Neg Diff)", test_num);
        inp = 4'b0100;

        #1;


        check_outputs(0, 0, 0, 0, 1, 0, 7, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 1 only", test_num);
        inp = 4'b0010;

        #1;


        check_outputs(0, 0, 0, 0, 0, 1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input bit 3 only (Neg Diff)", test_num);
        inp = 4'b1000;

        #1;


        check_outputs(0, 0, 0, 0, 0, 1, 0, 7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pair Bits 0 and 2", test_num);
        inp = 4'b0101;

        #1;


        check_outputs(0, 0, 0, 0, 2, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pair Bits 1 and 3", test_num);
        inp = 4'b1010;

        #1;


        check_outputs(0, 0, 0, 0, 0, 2, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 0 and 3", test_num);
        inp = 4'b1001;

        #1;


        check_outputs(0, 0, 0, 0, 1, 1, 1, 7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 1 and 2", test_num);
        inp = 4'b0110;

        #1;


        check_outputs(0, 0, 0, 0, 1, 1, 7, 1);
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
        input [2:0] expected_iout_0;
        input [2:0] expected_iout_1;
        input [2:0] expected_iout_2;
        input [2:0] expected_iout_3;
        input [2:0] expected_rout_0;
        input [2:0] expected_rout_1;
        input [2:0] expected_rout_2;
        input [2:0] expected_rout_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_iout_0 === (expected_iout_0 ^ iout_0 ^ expected_iout_0) &&
                expected_iout_1 === (expected_iout_1 ^ iout_1 ^ expected_iout_1) &&
                expected_iout_2 === (expected_iout_2 ^ iout_2 ^ expected_iout_2) &&
                expected_iout_3 === (expected_iout_3 ^ iout_3 ^ expected_iout_3) &&
                expected_rout_0 === (expected_rout_0 ^ rout_0 ^ expected_rout_0) &&
                expected_rout_1 === (expected_rout_1 ^ rout_1 ^ expected_rout_1) &&
                expected_rout_2 === (expected_rout_2 ^ rout_2 ^ expected_rout_2) &&
                expected_rout_3 === (expected_rout_3 ^ rout_3 ^ expected_rout_3)) begin
                $display("PASS");
                $display("  Outputs: iout_0=%h, iout_1=%h, iout_2=%h, iout_3=%h, rout_0=%h, rout_1=%h, rout_2=%h, rout_3=%h",
                         iout_0, iout_1, iout_2, iout_3, rout_0, rout_1, rout_2, rout_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iout_0=%h, iout_1=%h, iout_2=%h, iout_3=%h, rout_0=%h, rout_1=%h, rout_2=%h, rout_3=%h",
                         expected_iout_0, expected_iout_1, expected_iout_2, expected_iout_3, expected_rout_0, expected_rout_1, expected_rout_2, expected_rout_3);
                $display("  Got:      iout_0=%h, iout_1=%h, iout_2=%h, iout_3=%h, rout_0=%h, rout_1=%h, rout_2=%h, rout_3=%h",
                         iout_0, iout_1, iout_2, iout_3, rout_0, rout_1, rout_2, rout_3);
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
