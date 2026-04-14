`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] reg_no;
    wire [3:0] register;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg_no(reg_no),
        .register(register)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: reg_no = 2'b00", test_num);
        reg_no = 2'b00;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: reg_no = 2'b01", test_num);
        reg_no = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: reg_no = 2'b10", test_num);
        reg_no = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: reg_no = 2'b11", test_num);
        reg_no = 2'b11;
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_register;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_register === (expected_register ^ register ^ expected_register)) begin
                $display("PASS");
                $display("  Outputs: register=%h",
                         register);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: register=%h",
                         expected_register);
                $display("  Got:      register=%h",
                         register);
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
