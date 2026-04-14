`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [1:0] select;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 4'b0000;
            select = 2'b00;
            $display("Test Case 001: Select 0, Input 0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 4'b0001;
            select = 2'b00;
            $display("Test Case 002: Select 0, Input 0001 (bit 0 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 4'b0000;
            select = 2'b01;
            $display("Test Case 003: Select 1, Input 0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 4'b0010;
            select = 2'b01;
            $display("Test Case 004: Select 1, Input 0010 (bit 1 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 4'b0000;
            select = 2'b10;
            $display("Test Case 005: Select 2, Input 0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 4'b0100;
            select = 2'b10;
            $display("Test Case 006: Select 2, Input 0100 (bit 2 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 4'b0000;
            select = 2'b11;
            $display("Test Case 007: Select 3, Input 0000");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 4'b1000;
            select = 2'b11;
            $display("Test Case 008: Select 3, Input 1000 (bit 3 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 4'b1010;
            select = 2'b00;
            $display("Test Case 009: Select 0, Input 1010 (bit 0 is 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 4'b1010;
            select = 2'b01;
            $display("Test Case 010: Select 1, Input 1010 (bit 1 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            in = 4'b0101;
            select = 2'b10;
            $display("Test Case 011: Select 2, Input 0101 (bit 2 is 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            in = 4'b1111;
            select = 2'b11;
            $display("Test Case 012: Select 3, Input 1111 (bit 3 is 1)");
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
        testcase011();
        testcase012();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
