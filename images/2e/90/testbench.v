`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg noisy_signal;
    reg reset;
    wire clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .noisy_signal(noisy_signal),
        .reset(reset),
        .clean_signal(clean_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            noisy_signal = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial state after reset (input low)", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Short high pulse suppression", test_num);
            reset_dut();
            @(posedge clk);
            noisy_signal = 1;
            repeat(2) @(posedge clk);
            noisy_signal = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid stable high signal", test_num);
            reset_dut();
            @(posedge clk);
            noisy_signal = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Noise detection while in CLEAN state", test_num);
            reset_dut();

            @(posedge clk);
            noisy_signal = 1;
            repeat(10) @(posedge clk);

            noisy_signal = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signal jitter during IDLE", test_num);
            reset_dut();
            @(posedge clk);
            noisy_signal = 1; repeat(2) @(posedge clk);
            noisy_signal = 0; repeat(2) @(posedge clk);
            noisy_signal = 1; repeat(2) @(posedge clk);
            noisy_signal = 0; repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Recovery after noise event", test_num);
            reset_dut();

            noisy_signal = 1;
            repeat(10) @(posedge clk);

            noisy_signal = 0;
            @(posedge clk);

            noisy_signal = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_clean_signal;
        begin
            if (expected_clean_signal === (expected_clean_signal ^ clean_signal ^ expected_clean_signal)) begin
                $display("PASS");
                $display("  Outputs: clean_signal=%b",
                         clean_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_signal=%b",
                         expected_clean_signal);
                $display("  Got:      clean_signal=%b",
                         clean_signal);
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
        $dumpvars(0,clk, noisy_signal, reset, clean_signal);
    end

endmodule
