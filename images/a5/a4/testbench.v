`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    reg [1:0] ctrl;
    wire mem_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ctrl(ctrl),
        .mem_en(mem_en)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Valid Access - Expected mem_en=1");
        addr = 4'd8;
        ctrl = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Invalid Control (ctrl[0]=0) - Expected mem_en=0");
        addr = 4'd5;
        ctrl = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Invalid Control (ctrl[1]=1) - Expected mem_en=0");
        addr = 4'd10;
        ctrl = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Invalid Control (ctrl[0]=0, ctrl[1]=1) - Expected mem_en=0");
        addr = 4'd3;
        ctrl = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Boundary Address (0) - Expected mem_en=1");
        addr = 4'd0;
        ctrl = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Max 4-bit Address (15) - Expected mem_en=1");
        addr = 4'd15;
        ctrl = 2'b01;
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
        input expected_mem_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_en === (expected_mem_en ^ mem_en ^ expected_mem_en)) begin
                $display("PASS");
                $display("  Outputs: mem_en=%b",
                         mem_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_en=%b",
                         expected_mem_en);
                $display("  Got:      mem_en=%b",
                         mem_en);
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
