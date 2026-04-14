`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] IRshort;
    wire [15:0] IRlong;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRshort(IRshort),
        .IRlong(IRlong)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero value", test_num);
        IRshort = 11'h000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum positive value (1)", test_num);
        IRshort = 11'h001;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum positive value (1023)", test_num);
        IRshort = 11'h3FF;
        #1;

        check_outputs(16'h03FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones (-1)", test_num);
        IRshort = 11'h7FF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum negative value (-1024)", test_num);
        IRshort = 11'h400;
        #1;

        check_outputs(16'hFC00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary positive value (0x2AA)", test_num);
        IRshort = 11'h2AA;
        #1;

        check_outputs(16'h02AA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary negative value (0x555)", test_num);
        IRshort = 11'h555;
        #1;

        check_outputs(16'hFD55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check - almost negative", test_num);
        IRshort = 11'h3FE;
        #1;

        check_outputs(16'h03FE);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary check - almost positive", test_num);
        IRshort = 11'h401;
        #1;

        check_outputs(16'hFC01);
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
        input [15:0] expected_IRlong;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IRlong === (expected_IRlong ^ IRlong ^ expected_IRlong)) begin
                $display("PASS");
                $display("  Outputs: IRlong=%h",
                         IRlong);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRlong=%h",
                         expected_IRlong);
                $display("  Got:      IRlong=%h",
                         IRlong);
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
