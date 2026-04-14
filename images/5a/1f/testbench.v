`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] control;
    wire carry_out;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .control(control),
        .carry_out(carry_out),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'h5;
        B = 4'h2;
        control = 2'b00;
        #1;

        check_outputs(1'b0, 4'h7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'hF;
        B = 4'h1;
        control = 2'b00;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hA;
        B = 4'h4;
        control = 2'b01;
        #1;

        check_outputs(1'b0, 4'h6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'h2;
        B = 4'h5;
        control = 2'b01;


        #1;



        check_outputs(1'b1, 4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1010;
        B = 4'b1100;
        control = 2'b10;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1010;
        B = 4'b0110;
        control = 2'b11;
        #1;

        check_outputs(1'b0, 4'b1110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'hF;
        B = 4'hF;
        control = 2'b10;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'h0;
        B = 4'h0;
        control = 2'b11;
        #1;

        check_outputs(1'b0, 4'h0);
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
        input expected_carry_out;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h",
                         carry_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h",
                         expected_carry_out, expected_result);
                $display("  Got:      carry_out=%b, result=%h",
                         carry_out, result);
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
