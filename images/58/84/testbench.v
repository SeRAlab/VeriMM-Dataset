`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [22:0] address;
    reg is_sector1_writable;
    reg is_sector2_writable;
    reg is_sector3_writable;
    reg is_sector4_writable;
    reg is_sector5_writable;
    wire is_addr_writable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .is_sector1_writable(is_sector1_writable),
        .is_sector2_writable(is_sector2_writable),
        .is_sector3_writable(is_sector3_writable),
        .is_sector4_writable(is_sector4_writable),
        .is_sector5_writable(is_sector5_writable),
        .is_addr_writable(is_addr_writable)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing Sector 1 Write Access (Enabled)", test_num);
        address = 23'h000000;
        is_sector1_writable = 1;
        is_sector2_writable = 0;
        is_sector3_writable = 0;
        is_sector4_writable = 0;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing Sector 1 Write Access (Disabled)", test_num);
        address = 23'h080000;
        is_sector1_writable = 0;
        is_sector2_writable = 1;
        is_sector3_writable = 1;
        is_sector4_writable = 1;
        is_sector5_writable = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing Sector 2 Write Access (Enabled)", test_num);
        address = 23'h100000;
        is_sector1_writable = 0;
        is_sector2_writable = 1;
        is_sector3_writable = 0;
        is_sector4_writable = 0;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing Sector 2 Write Access (Disabled)", test_num);
        address = 23'h1FFFFF;
        is_sector1_writable = 1;
        is_sector2_writable = 0;
        is_sector3_writable = 1;
        is_sector4_writable = 1;
        is_sector5_writable = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing Sector 3 Write Access (Enabled)", test_num);
        address = 23'h200000;
        is_sector1_writable = 0;
        is_sector2_writable = 0;
        is_sector3_writable = 1;
        is_sector4_writable = 0;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing Sector 4 Write Access (Enabled)", test_num);
        address = 23'h300000;
        is_sector1_writable = 0;
        is_sector2_writable = 0;
        is_sector3_writable = 0;
        is_sector4_writable = 1;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing Sector 5 Write Access (Enabled)", test_num);
        address = 23'h400000;
        is_sector1_writable = 0;
        is_sector2_writable = 0;
        is_sector3_writable = 0;
        is_sector4_writable = 0;
        is_sector5_writable = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing Sector 5 Upper Boundary (Disabled)", test_num);
        address = 23'h7FFFFF;
        is_sector1_writable = 1;
        is_sector2_writable = 1;
        is_sector3_writable = 1;
        is_sector4_writable = 1;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: All Sectors Disabled", test_num);
        address = 23'h123456;
        is_sector1_writable = 0;
        is_sector2_writable = 0;
        is_sector3_writable = 0;
        is_sector4_writable = 0;
        is_sector5_writable = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: All Sectors Enabled", test_num);
        address = 23'h654321;
        is_sector1_writable = 1;
        is_sector2_writable = 1;
        is_sector3_writable = 1;
        is_sector4_writable = 1;
        is_sector5_writable = 1;
        #1;

        check_outputs(1'b1);
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
        input expected_is_addr_writable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_addr_writable === (expected_is_addr_writable ^ is_addr_writable ^ expected_is_addr_writable)) begin
                $display("PASS");
                $display("  Outputs: is_addr_writable=%b",
                         is_addr_writable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_addr_writable=%b",
                         expected_is_addr_writable);
                $display("  Got:      is_addr_writable=%b",
                         is_addr_writable);
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
