`timescale 1ns/1ps

module fsm_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg y;
    wire w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module dut (
        .clk(clk),
        .y(y),
        .w(w)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            y = 0;


            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            y = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            y = 0; @(posedge clk);
            y = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            y = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            y = 1; @(posedge clk);
            y = 0; @(posedge clk);
            y = 1; @(posedge clk);
            y = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            y = 1; @(posedge clk);
            y = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            y = 1; @(posedge clk);
            y = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_module Testbench");
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
        input expected_w;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%b",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b",
                         expected_w);
                $display("  Got:      w=%b",
                         w);
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
        $dumpvars(0,clk, y, w);
    end

endmodule
