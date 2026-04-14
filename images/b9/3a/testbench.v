`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [22:0] address;
    wire [22:0] flash_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .flash_addr(flash_addr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros (Lower Bound)", test_num);
        address = 23'h000000;
        #10;
        #1;

        check_outputs(23'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones (Upper Bound)", test_num);
        address = 23'h7FFFFF;
        #10;
        #1;

        check_outputs(23'h7FFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Least Significant Bit", test_num);
        address = 23'h000001;
        #10;
        #1;

        check_outputs(23'h000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Most Significant Bit", test_num);
        address = 23'h400000;
        #10;
        #1;

        check_outputs(23'h400000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bit Pattern A", test_num);
        address = 23'h555555;
        #10;
        #1;

        check_outputs(23'h555555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bit Pattern B", test_num);
        address = 23'h2AAAAA;
        #10;
        #1;

        check_outputs(23'h2AAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Random Memory Offset", test_num);
        address = 23'h123456;
        #10;
        #1;

        check_outputs(23'h123456);
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
        input [22:0] expected_flash_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flash_addr === (expected_flash_addr ^ flash_addr ^ expected_flash_addr)) begin
                $display("PASS");
                $display("  Outputs: flash_addr=%h",
                         flash_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flash_addr=%h",
                         expected_flash_addr);
                $display("  Got:      flash_addr=%h",
                         flash_addr);
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
