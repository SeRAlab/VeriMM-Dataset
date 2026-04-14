`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] A;
    wire [15:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .A(A),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 16'd100;
        y = 16'd50;
        $display("Test %0d: Simple Addition and Subtraction (100, 50)", test_num);
        #1;

        check_outputs(16'd150, 16'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 16'h0000;
        y = 16'h0000;
        $display("Test %0d: Zero inputs", test_num);
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 16'hFFFF;
        y = 16'h0001;
        $display("Test %0d: Addition overflow (0xFFFF + 1)", test_num);
        #1;

        check_outputs(16'h0000, 16'hFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 16'd10;
        y = 16'd20;
        $display("Test %0d: Subtraction underflow (10 - 20)", test_num);

        #1;


        check_outputs(16'h001E, 16'hFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 16'h1234;
        y = 16'h1234;
        $display("Test %0d: Equal values", test_num);
        #1;

        check_outputs(16'h2468, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 16'hFFFF;
        y = 16'hFFFF;
        $display("Test %0d: Maximum inputs (0xFFFF, 0xFFFF)", test_num);

        #1;


        check_outputs(16'hFFFE, 16'h0000);
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
        input [15:0] expected_A;
        input [15:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h",
                         A, B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h",
                         expected_A, expected_B);
                $display("  Got:      A=%h, B=%h",
                         A, B);
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
