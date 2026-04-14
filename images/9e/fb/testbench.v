`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] gray;
    wire [11:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gray(gray),
        .bin(bin)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All zeros", test_num);
        gray = 12'h000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Least Significant Bit", test_num);
        gray = 12'h001;
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Gray 3 (Bin 2)", test_num);
        gray = 12'h003;
        #1;

        check_outputs(12'h002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Gray 2 (Bin 3)", test_num);
        gray = 12'h002;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Binary All Ones (Gray 800)", test_num);
        gray = 12'h800;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Pattern AAA", test_num);
        gray = 12'hAAA;
        #1;

        check_outputs(12'hCCC);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Pattern 555", test_num);
        gray = 12'h555;
        #1;

        check_outputs(12'h666);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Gray All Ones", test_num);
        gray = 12'hFFF;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Midpoint Value", test_num);
        gray = 12'hC00;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Arbitrary Pattern", test_num);
        gray = 12'h924;










        #1;











        check_outputs(12'hE67);
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
        input [11:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
