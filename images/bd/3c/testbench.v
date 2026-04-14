`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sel;
    reg [71:0] x0;
    reg [71:0] x1;
    wire [71:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x0 (Zeros) with sel=0", test_num);
        sel = 1'b0;
        x0 = 72'h000000000000000000;
        x1 = 72'hFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(72'h000000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x1 (Ones) with sel=1", test_num);
        sel = 1'b1;
        x0 = 72'h000000000000000000;
        x1 = 72'hFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x0 (Pattern A) with sel=0", test_num);
        sel = 1'b0;
        x0 = 72'hAAAAAAAAAAAAAAAAAA;
        x1 = 72'h555555555555555555;
        #1;

        check_outputs(72'hAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x1 (Pattern 5) with sel=1", test_num);
        sel = 1'b1;
        x0 = 72'hAAAAAAAAAAAAAAAAAA;
        x1 = 72'h555555555555555555;
        #1;

        check_outputs(72'h555555555555555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x0 (Random) with sel=0", test_num);
        sel = 1'b0;
        x0 = 72'h123456789ABCDEF012;
        x1 = 72'hFEDCBA9876543210FE;
        #1;

        check_outputs(72'h123456789ABCDEF012);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select x1 (Random) with sel=1", test_num);
        sel = 1'b1;
        x0 = 72'h123456789ABCDEF012;
        x1 = 72'hFEDCBA9876543210FE;
        #1;

        check_outputs(72'hFEDCBA9876543210FE);
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
        input [71:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
