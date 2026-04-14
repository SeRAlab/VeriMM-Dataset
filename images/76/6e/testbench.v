`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CIN;
    reg MODE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .MODE(MODE),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Basic (MODE=0, CIN=0)", test_num);
        A = 16'd100;
        B = 16'd250;
        MODE = 1'b0;
        CIN = 1'b0;
        #1;

        check_outputs(16'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - With Carry Input (MODE=0, CIN=1)", test_num);
        A = 16'h1234;
        B = 16'h1111;
        MODE = 1'b0;
        CIN = 1'b1;
        #1;

        check_outputs(16'h2346);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Overflow/Wrap around (MODE=0)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        MODE = 1'b0;
        CIN = 1'b0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition - Large values (MODE=0)", test_num);
        A = 16'h7FFF;
        B = 16'h7FFF;
        MODE = 1'b0;
        CIN = 1'b1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Basic (MODE=1, CIN=0)", test_num);
        A = 16'd500;
        B = 16'd200;
        MODE = 1'b1;
        CIN = 1'b0;
        #1;

        check_outputs(16'd300);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - With Carry Input (MODE=1, CIN=1)", test_num);
        A = 16'd500;
        B = 16'd200;
        MODE = 1'b1;
        CIN = 1'b1;
        #1;

        check_outputs(16'd299);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Underflow (MODE=1)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        MODE = 1'b1;
        CIN = 1'b0;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Underflow with CIN (MODE=1)", test_num);
        A = 16'h0000;
        B = 16'h0001;
        MODE = 1'b1;
        CIN = 1'b1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Result zero (MODE=1)", test_num);
        A = 16'hABCD;
        B = 16'hABCD;
        MODE = 1'b1;
        CIN = 1'b0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction - Max A, Max B (MODE=1)", test_num);
        A = 16'hFFFF;
        B = 16'hFFFF;
        MODE = 1'b1;
        CIN = 1'b1;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
