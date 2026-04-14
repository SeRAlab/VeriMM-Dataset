`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg freqin;
    wire [23:0] frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .freqin(freqin),
        .frequency(frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            freqin = 0;
            #(MEASUREMENT_WINDOW * 2);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing 5MHz signal (Expected Output: 100)", test_num);
            reset_dut();
            fork

                begin
                    repeat(100) begin
                        freqin = 1; #100;
                        freqin = 0; #100;
                    end
                end
                begin
                    #(MEASUREMENT_WINDOW * 2);
                end
            join
            #1;
            #1;

            check_outputs(24'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing 2MHz signal (Expected Output: 40)", test_num);
            reset_dut();
            fork
                begin
                    repeat(40) begin
                        freqin = 1; #250;
                        freqin = 0; #250;
                    end
                end
                begin
                    #(MEASUREMENT_WINDOW * 2);
                end
            join
            #1;
            #1;

            check_outputs(24'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing 0Hz signal (Expected Output: 0)", test_num);
            reset_dut();
            freqin = 0;
            #(MEASUREMENT_WINDOW * 2);
            #1;
            #1;

            check_outputs(24'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing 10MHz signal (Expected Output: 200)", test_num);
            reset_dut();
            fork
                begin
                    repeat(200) begin
                        freqin = 1; #50;
                        freqin = 0; #50;
                    end
                end
                begin
                    #(MEASUREMENT_WINDOW * 2);
                end
            join
            #1;
            #1;

            check_outputs(24'd200);
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
        input [23:0] expected_frequency;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h",
                         frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h",
                         expected_frequency);
                $display("  Got:      frequency=%h",
                         frequency);
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
        $dumpvars(0,clk, freqin, frequency);
    end

endmodule
