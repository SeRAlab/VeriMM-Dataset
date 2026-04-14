`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] x;
    wire [2:0] cout;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .cout(cout),
        .s(s)
    );
    task testcase001;

        begin
            x = 7'b0000000;
            $display("Test 001: x=%b (All zeros)", x);
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            x = 7'b1111111;
            $display("Test 002: x=%b (All ones)", x);
            #1;

            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            x = 7'b1000000;
            $display("Test 003: x=%b (Only x[6])", x);
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            x = 7'b0111000;
            $display("Test 004: x=%b (Only x[5:3]=7)", x);
            #1;

            check_outputs(3'b011, 1'b1);
        end
        endtask

    task testcase005;

        begin
            x = 7'b0000111;
            $display("Test 005: x=%b (Only x[2:0]=7)", x);
            #1;

            check_outputs(3'b011, 1'b1);
        end
        endtask

    task testcase006;

        begin
            x = 7'b0100100;
            $display("Test 006: x=%b (Carry check, Sum=8)", x);
            #1;

            check_outputs(3'b100, 1'b0);
        end
        endtask

    task testcase007;

        begin
            x = 7'b1010011;
            $display("Test 007: x=%b (Sum=6)", x);
            #1;

            check_outputs(3'b011, 1'b0);
        end
        endtask

    task testcase008;

        begin
            x = 7'b0110101;
            $display("Test 008: x=%b (Sum=11)", x);
            #1;

            check_outputs(3'b101, 1'b1);
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
        input [2:0] expected_cout;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s=%b",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s=%b",
                         expected_cout, expected_s);
                $display("  Got:      cout=%h, s=%b",
                         cout, s);
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
