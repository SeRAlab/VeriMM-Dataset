`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg [4:0] a4;
    reg [1:0] choose;
    wire [4:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .choose(choose),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select a1 (choose=00)");
            a1 = 5'b10101;
            a2 = 5'b00000;
            a3 = 5'b11111;
            a4 = 5'b01010;
            choose = 2'b00;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select a2 (choose=01)");
            a1 = 5'b10101;
            a2 = 5'b01100;
            a3 = 5'b11111;
            a4 = 5'b01010;
            choose = 2'b01;
            #1;

            check_outputs(5'b01100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select a3 (choose=10)");
            a1 = 5'b10101;
            a2 = 5'b01100;
            a3 = 5'b10001;
            a4 = 5'b01010;
            choose = 2'b10;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select a4 (choose=11)");
            a1 = 5'b10101;
            a2 = 5'b01100;
            a3 = 5'b10001;
            a4 = 5'b11110;
            choose = 2'b11;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Boundary values (All zeros, choose a1)");
            a1 = 5'b00000;
            a2 = 5'b11111;
            a3 = 5'b11111;
            a4 = 5'b11111;
            choose = 2'b00;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Boundary values (All ones, choose a4)");
            a1 = 5'b00000;
            a2 = 5'b00000;
            a3 = 5'b00000;
            a4 = 5'b11111;
            choose = 2'b11;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Alternating bits (choose a2)");
            a1 = 5'b00000;
            a2 = 5'b10101;
            a3 = 5'b01010;
            a4 = 5'b11111;
            choose = 2'b01;
            #1;

            check_outputs(5'b10101);
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
        input [4:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
