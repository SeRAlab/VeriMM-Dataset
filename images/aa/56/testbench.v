`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i0;
    reg [31:0] i1;
    wire [31:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        i0 = 32'd100;
        i1 = 32'd40;
        $display("Testcase %0d: i0=%d, i1=%d", test_num, i0, i1);
        #1;

        check_outputs(32'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i0 = 32'hA5A5A5A5;
        i1 = 32'd0;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i0 = 32'hFFFFFFFF;
        i1 = 32'hFFFFFFFF;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i0 = 32'h00000000;
        i1 = 32'h00000001;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i0 = 32'h80000000;
        i1 = 32'h00000001;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i0 = 32'h12345678;
        i1 = 32'h02345670;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'h10000008);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i0 = 32'h7FFFFFFF;
        i1 = 32'hFFFFFFFF;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i0 = 32'h00000000;
        i1 = 32'h00000000;
        $display("Testcase %0d: i0=%h, i1=%h", test_num, i0, i1);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
