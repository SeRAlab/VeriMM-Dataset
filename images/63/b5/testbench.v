`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [22:0] address;
    wire is_addr_within_valid_range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .is_addr_within_valid_range(is_addr_within_valid_range)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Lower Bound (0x000000)", test_num);
        address = 23'h000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Small Offset (0x000005)", test_num);
        address = 23'h000005;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Mid-range value (0x1FFFFF)", test_num);
        address = 23'h1FFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Common Segment Boundary (0x200000)", test_num);
        address = 23'h200000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Upper Range Boundary (0x3FFFFF)", test_num);
        address = 23'h3FFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Just Outside Upper Boundary (0x400000)", test_num);
        address = 23'h400000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: High address pattern (0x555555)", test_num);
        address = 23'h555555;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Maximum Address (0x7FFFFF)", test_num);
        address = 23'h7FFFFF;
        #1;

        check_outputs(1'b0);
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
        input expected_is_addr_within_valid_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_addr_within_valid_range === (expected_is_addr_within_valid_range ^ is_addr_within_valid_range ^ expected_is_addr_within_valid_range)) begin
                $display("PASS");
                $display("  Outputs: is_addr_within_valid_range=%b",
                         is_addr_within_valid_range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_addr_within_valid_range=%b",
                         expected_is_addr_within_valid_range);
                $display("  Got:      is_addr_within_valid_range=%b",
                         is_addr_within_valid_range);
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
