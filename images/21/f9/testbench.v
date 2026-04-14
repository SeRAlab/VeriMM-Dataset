`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg noisy_signal;
    reg rst;
    reg threshold;
    wire clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .noisy_signal(noisy_signal),
        .rst(rst),
        .threshold(threshold),
        .clean_signal(clean_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            noisy_signal = 0;
            threshold = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Stable Zero Input", test_num);
            reset_dut();
            noisy_signal = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Stable One Input (Threshold 0)", test_num);
            reset_dut();
            threshold = 0;
            @(posedge clk);
            noisy_signal = 1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Filter 1-cycle High Glitch", test_num);
            reset_dut();
            threshold = 0;
            @(posedge clk);
            noisy_signal = 1;
            @(posedge clk);
            noisy_signal = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Filter 1-cycle Low Glitch", test_num);
            reset_dut();
            threshold = 0;

            noisy_signal = 1;
            repeat(10) @(posedge clk);

            noisy_signal = 0;
            @(posedge clk);
            noisy_signal = 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Increased Threshold Glitch Filtering", test_num);
            reset_dut();
            threshold = 1;
            @(posedge clk);
            noisy_signal = 1;
            repeat(2) @(posedge clk);
            noisy_signal = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Valid Signal with High Threshold", test_num);
            reset_dut();
            threshold = 1;
            @(posedge clk);
            noisy_signal = 1;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Rapid Oscillation Suppression", test_num);
            reset_dut();
            threshold = 1;
            repeat(10) begin
                noisy_signal = 1; @(posedge clk);
                noisy_signal = 0; @(posedge clk);
            end
            #1;

            check_outputs(1'b0);
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
        $dumpvars(0,clk, noisy_signal, rst, threshold, clean_signal);
    end

endmodule
