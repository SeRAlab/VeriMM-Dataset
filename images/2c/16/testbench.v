`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_in;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signal_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Steady Zero Input (0, 0, 0)", test_num);
            reset_dut();
            signal_in = 0; @(posedge clk);
            signal_in = 0; @(posedge clk);
            signal_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Steady One Input (1, 1, 1)", test_num);
            reset_dut();
            signal_in = 1; @(posedge clk);
            signal_in = 1; @(posedge clk);
            signal_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Majority One with Zero Noise (1, 0, 1)", test_num);
            reset_dut();
            signal_in = 1; @(posedge clk);
            signal_in = 0; @(posedge clk);
            signal_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Majority Zero with One Noise (0, 1, 0)", test_num);
            reset_dut();
            signal_in = 0; @(posedge clk);
            signal_in = 1; @(posedge clk);
            signal_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Transition to High (0, 1, 1)", test_num);
            reset_dut();
            signal_in = 0; @(posedge clk);
            signal_in = 1; @(posedge clk);
            signal_in = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Transition to Low (1, 0, 0)", test_num);
            reset_dut();
            signal_in = 1; @(posedge clk);
            signal_in = 0; @(posedge clk);
            signal_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Majority One (1, 1, 0)", test_num);
            reset_dut();
            signal_in = 1; @(posedge clk);
            signal_in = 1; @(posedge clk);
            signal_in = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Majority Zero (0, 0, 1)", test_num);
            reset_dut();
            signal_in = 0; @(posedge clk);
            signal_in = 0; @(posedge clk);
            signal_in = 1; @(posedge clk);
            #1;
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
        $display("noise_suppression Testbench");
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
        input expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
        $dumpvars(0,clk, reset, signal_in, signal_out);
    end

endmodule
