`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] multiplicand;
    reg [2:0] multiplier;
    reg start;
    wire done;
    wire [5:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .start(start),
        .done(done),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            multiplicand = 0;
            multiplier = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task run_multiplication;

        input [2:0] a;
        input [2:0] b;
        begin
            multiplicand = a;
            multiplier = b;
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;



            while (!done) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1, a * b);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: 3 * 2", test_num);
            reset_dut();
            run_multiplication(3, 2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 7 * 7", test_num);
            reset_dut();
            run_multiplication(7, 7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 0 * 5", test_num);
            reset_dut();
            run_multiplication(0, 5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 6 * 0", test_num);
            reset_dut();
            run_multiplication(6, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 1 * 4", test_num);
            reset_dut();
            run_multiplication(1, 4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 4 * 5", test_num);
            reset_dut();
            run_multiplication(4, 5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 5 * 4", test_num);
            reset_dut();
            run_multiplication(5, 4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: 4 * 2", test_num);
            reset_dut();
            run_multiplication(4, 2);
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
        input expected_done;
        input [5:0] expected_p;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: done=%b, p=%h",
                         done, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, p=%h",
                         expected_done, expected_p);
                $display("  Got:      done=%b, p=%h",
                         done, p);
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
        $dumpvars(0,clk, multiplicand, multiplier, start, done, p);
    end

endmodule
