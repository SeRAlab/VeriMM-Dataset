`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire error;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .error(error),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Positive Result)", test_num);
        a = 8'sd15; b = 8'sd25; op = 2'b00;
        #1;

        check_outputs(1'b0, 8'sd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Positive Overflow)", test_num);
        a = 8'sd120; b = 8'sd10; op = 2'b00;
        #1;

        check_outputs(1'b1, 8'b10000010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Negative Overflow)", test_num);
        a = -8'sd120; b = -8'sd10; op = 2'b00;
        #1;

        check_outputs(1'b1, 8'b01111110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Basic)", test_num);
        a = 8'sd50; b = 8'sd20; op = 2'b01;
        #1;

        check_outputs(1'b0, 8'sd30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Overflow Positive)", test_num);
        a = 8'sd120; b = -8'sd10; op = 2'b01;
        #1;

        check_outputs(1'b1, 8'b10000010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (Positive)", test_num);
        a = 8'sd12; b = 8'sd5; op = 2'b10;
        #1;

        check_outputs(1'b0, 8'sd60);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication (Negative)", test_num);
        a = -8'sd6; b = 8'sd4; op = 2'b10;
        #1;

        check_outputs(1'b0, -8'sd24);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (Basic)", test_num);
        a = 8'sd80; b = 8'sd4; op = 2'b11;
        #1;

        check_outputs(1'b0, 8'sd20);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division (Signed)", test_num);
        a = -8'sd40; b = 8'sd5; op = 2'b11;
        #1;

        check_outputs(1'b0, -8'sd8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by Zero", test_num);
        a = 8'sd100; b = 8'sd0; op = 2'b11;
        #1;

        check_outputs(1'b1, 8'b0);
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
        input expected_error;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: error=%b, result=%h",
                         error, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, result=%h",
                         expected_error, expected_result);
                $display("  Got:      error=%b, result=%h",
                         error, result);
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
