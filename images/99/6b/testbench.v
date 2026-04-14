`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] reg_field0;
    reg [1:0] reg_field1;
    reg [1:0] select;
    wire [1:0] write_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg_field0(reg_field0),
        .reg_field1(reg_field1),
        .select(select),
        .write_address(write_address)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 00 (Fixed address)", test_num);
            select = 2'b00;
            reg_field0 = 2'b11;
            reg_field1 = 2'b01;
            #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 01 (reg_field0)", test_num);
            select = 2'b01;
            reg_field0 = 2'b10;
            reg_field1 = 2'b11;
            #5;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 01 (reg_field0 alternative data)", test_num);
            select = 2'b01;
            reg_field0 = 2'b01;
            reg_field1 = 2'b00;
            #5;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 10 (reg_field1)", test_num);
            select = 2'b10;
            reg_field0 = 2'b00;
            reg_field1 = 2'b11;
            #5;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 10 (reg_field1 alternative data)", test_num);
            select = 2'b10;
            reg_field0 = 2'b11;
            reg_field1 = 2'b00;
            #5;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select 11 (Default output 10)", test_num);
            select = 2'b11;
            reg_field0 = 2'b00;
            reg_field1 = 2'b01;
            #5;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_write_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_write_address === (expected_write_address ^ write_address ^ expected_write_address)) begin
                $display("PASS");
                $display("  Outputs: write_address=%h",
                         write_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_address=%h",
                         expected_write_address);
                $display("  Got:      write_address=%h",
                         write_address);
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
