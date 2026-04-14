`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg mode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .A(A),
        .B(B),
        .mode(mode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd15;
        B = 8'd10;
        mode = 0;
        $display("Test %0d: Basic Addition (%d + %d)", test_num, A, B);
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'hFF;
        B = 8'h01;
        mode = 0;
        $display("Test %0d: Addition Overflow (%h + %h)", test_num, A, B);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd50;
        B = 8'd20;
        mode = 1;
        $display("Test %0d: Basic Subtraction (%d - %d)", test_num, A, B);
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd128;
        B = 8'd128;
        mode = 1;
        $display("Test %0d: Subtraction Result Zero (%d - %d)", test_num, A, B);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'd10;
        B = 8'd15;
        mode = 1;
        $display("Test %0d: Subtraction Underflow (%d - %d)", test_num, A, B);
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'h00;
        B = 8'h00;
        mode = 0;
        $display("Test %0d: Zero Addition", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'hA5;
        B = 8'h00;
        mode = 1;
        $display("Test %0d: Subtraction of Zero", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'd200;
        B = 8'd100;
        mode = 0;
        $display("Test %0d: Large Addition (%d + %d)", test_num, A, B);
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'hFF;
        B = 8'hFE;
        mode = 1;
        $display("Test %0d: Max Value Subtraction (%h - %h)", test_num, A, B);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'd40;
        B = 8'd20;


        mode = 0;
        $display("Test %0d: Mode Switch (Add)", test_num);
        #1;


        mode = 1;
        $display("Test %0d: Mode Switch (Sub)", test_num);
        #1;

        check_outputs(8'd20);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
