`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] Address;
    reg Write;
    wire [21:0] EnableRegister;
    wire EnableStart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Write(Write),
        .EnableRegister(EnableRegister),
        .EnableStart(EnableStart)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Checking EnableStart at Address 0x08C (Write=0)");
            Address = 9'h08C;
            Write = 1'b0;


            #1;



            check_outputs(22'h000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Checking EnableStart at Address 0x08C (Write=1)");
            Address = 9'h08C;
            Write = 1'b1;



            #1;




            check_outputs(22'h000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Checking Non-matching Address (0x0A5)");
            Address = 9'h0A5;
            Write = 1'b1;

            #1;


            check_outputs(22'h000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Checking Register Address 0x000 with Write=0");
            Address = 9'h000;
            Write = 1'b0;

            #1;


            check_outputs(22'h000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Checking Register Address 0x000 with Write=1");
            Address = 9'h000;
            Write = 1'b1;



            #1;




            check_outputs(22'h000001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Checking Boundary Address 0x1FF");
            Address = 9'h1FF;
            Write = 1'b1;
            #1;

            check_outputs(22'h000000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: All Zeros Input");
            Address = 9'h000;
            Write = 1'b0;
            #1;

            check_outputs(22'h000000, 1'b0);
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
        input [21:0] expected_EnableRegister;
        input expected_EnableStart;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EnableRegister === (expected_EnableRegister ^ EnableRegister ^ expected_EnableRegister) &&
                expected_EnableStart === (expected_EnableStart ^ EnableStart ^ expected_EnableStart)) begin
                $display("PASS");
                $display("  Outputs: EnableRegister=%h, EnableStart=%b",
                         EnableRegister, EnableStart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EnableRegister=%h, EnableStart=%b",
                         expected_EnableRegister, expected_EnableStart);
                $display("  Got:      EnableRegister=%h, EnableStart=%b",
                         EnableRegister, EnableStart);
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
