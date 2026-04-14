`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in_vector;
    wire [9:0] max_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vector(in_vector),
        .max_value(max_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Testing initial zero state");

        in_vector = 10'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Loading first non-zero value (42)");
        in_vector = 10'd42;
        #1;

        check_outputs(10'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Inputting smaller value (15) - Max should remain 42");
        in_vector = 10'd15;
        #1;

        check_outputs(10'd42);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Inputting larger value (512) - Max should update");
        in_vector = 10'd512;
        #1;

        check_outputs(10'd512);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Inputting 1023 (All bits set) - Max should update");
        in_vector = 10'd1023;
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Inputting zero - Max should remain 1023");
        in_vector = 10'd0;
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Inputting 768 - Max should remain 1023");
        in_vector = 10'd768;
        #1;

        check_outputs(10'd1023);
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
        input [9:0] expected_max_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_value === (expected_max_value ^ max_value ^ expected_max_value)) begin
                $display("PASS");
                $display("  Outputs: max_value=%h",
                         max_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_value=%h",
                         expected_max_value);
                $display("  Got:      max_value=%h",
                         max_value);
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
