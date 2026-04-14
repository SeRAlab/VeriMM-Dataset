`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR_gt_0;
    reg AR_lt_0;
    reg clk;
    reg reset_b;
    reg start;
    wire Clr_CR;
    wire Div_AR_x2_CR;
    wire Ld_AR_BR;
    wire Mul_BR_x2_CR;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR_gt_0(AR_gt_0),
        .AR_lt_0(AR_lt_0),
        .clk(clk),
        .reset_b(reset_b),
        .start(start),
        .Clr_CR(Clr_CR),
        .Div_AR_x2_CR(Div_AR_x2_CR),
        .Ld_AR_BR(Ld_AR_BR),
        .Mul_BR_x2_CR(Mul_BR_x2_CR),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_b = 0;
            start = 0;
            AR_gt_0 = 0;
            AR_lt_0 = 0;
            @(posedge clk);
            #1;
            reset_b = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Multiplication Logic (AR > 0)", test_num);
            reset_dut();


            start = 1;
            AR_gt_0 = 1;
            AR_lt_0 = 0;
            @(posedge clk);
            #1 start = 0;


            repeat(4) @(posedge clk);



            #1;




            check_outputs(0, 0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Division Logic (AR < 0)", test_num);
            reset_dut();

            start = 1;
            AR_gt_0 = 0;
            AR_lt_0 = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(4) @(posedge clk);


            #1;



            check_outputs(0, 1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Clear Logic (AR = 0)", test_num);
            reset_dut();

            start = 1;
            AR_gt_0 = 0;
            AR_lt_0 = 0;
            @(posedge clk);
            #1 start = 0;

            repeat(4) @(posedge clk);


            #1;



            check_outputs(1, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Interrupt during Operation", test_num);
            reset_dut();

            start = 1;
            AR_gt_0 = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);

            reset_b = 0;
            #10;
            reset_b = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0, 0);
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
        input expected_Clr_CR;
        input expected_Div_AR_x2_CR;
        input expected_Ld_AR_BR;
        input expected_Mul_BR_x2_CR;
        input expected_done;
        begin
            if (expected_Clr_CR === (expected_Clr_CR ^ Clr_CR ^ expected_Clr_CR) &&
                expected_Div_AR_x2_CR === (expected_Div_AR_x2_CR ^ Div_AR_x2_CR ^ expected_Div_AR_x2_CR) &&
                expected_Ld_AR_BR === (expected_Ld_AR_BR ^ Ld_AR_BR ^ expected_Ld_AR_BR) &&
                expected_Mul_BR_x2_CR === (expected_Mul_BR_x2_CR ^ Mul_BR_x2_CR ^ expected_Mul_BR_x2_CR) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: Clr_CR=%b, Div_AR_x2_CR=%b, Ld_AR_BR=%b, Mul_BR_x2_CR=%b, done=%b",
                         Clr_CR, Div_AR_x2_CR, Ld_AR_BR, Mul_BR_x2_CR, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Clr_CR=%b, Div_AR_x2_CR=%b, Ld_AR_BR=%b, Mul_BR_x2_CR=%b, done=%b",
                         expected_Clr_CR, expected_Div_AR_x2_CR, expected_Ld_AR_BR, expected_Mul_BR_x2_CR, expected_done);
                $display("  Got:      Clr_CR=%b, Div_AR_x2_CR=%b, Ld_AR_BR=%b, Mul_BR_x2_CR=%b, done=%b",
                         Clr_CR, Div_AR_x2_CR, Ld_AR_BR, Mul_BR_x2_CR, done);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,AR_gt_0, AR_lt_0, clk, reset_b, start, Clr_CR, Div_AR_x2_CR, Ld_AR_BR, Mul_BR_x2_CR, done);
    end

endmodule
