`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg clk;
    wire NotQ;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .NotQ(NotQ),
        .Q(Q)
    );
    task reset_inputs;

    begin
        D = 0;
        clk = 0;
        #10;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = 1;
        $display("Testcase %03d: clk=1, D=0 (Transparency)", test_num);
        clk = 1;
        D = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = 2;
        $display("Testcase %03d: clk=1, D=1 (Transparency)", test_num);
        clk = 1;
        D = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = 3;
        $display("Testcase %03d: clk 1->0, holding D=1", test_num);

        clk = 1;
        D = 1;
        #10;

        clk = 0;
        #5;
        D = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = 4;
        $display("Testcase %03d: clk 1->0, holding D=0", test_num);

        clk = 1;
        D = 0;
        #10;

        clk = 0;
        #5;
        D = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = 5;
        $display("Testcase %03d: Multiple D changes while clk=1", test_num);
        clk = 1;
        D = 0; #5;
        D = 1; #5;
        D = 0; #5;
        D = 1; #10;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_NotQ;
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_NotQ === (expected_NotQ ^ NotQ ^ expected_NotQ) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: NotQ=%b, Q=%b",
                         NotQ, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NotQ=%b, Q=%b",
                         expected_NotQ, expected_Q);
                $display("  Got:      NotQ=%b, Q=%b",
                         NotQ, Q);
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
