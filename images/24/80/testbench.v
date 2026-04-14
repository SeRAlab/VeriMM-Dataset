`timescale 1ns/1ps

module goertzel_algorithm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sample;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    goertzel_algorithm dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sample = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Silence)", test_num);
            reset_dut();

            for (i = 0; i < N_SAMPLES; i = i + 1) begin
                sample = 0;
                @(posedge clk);
            end


            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        real freq_target;
        real fs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Target Frequency Detected", test_num);
            reset_dut();

            fs = 8000.0;
            freq_target = 1000.0;

            for (i = 0; i < N_SAMPLES; i = i + 1) begin


                sample = $rtoi(10000.0 * $sin(2.0 * pi * freq_target * i / fs));
                @(posedge clk);
            end

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        real freq_wrong;
        real fs;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Non-Matching Frequency (Interference)", test_num);
            reset_dut();

            fs = 8000.0;
            freq_wrong = 2500.0;

            for (i = 0; i < N_SAMPLES; i = i + 1) begin
                sample = $rtoi(10000.0 * $sin(2.0 * pi * freq_wrong * i / fs));
                @(posedge clk);
            end

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Noise Burst", test_num);
            reset_dut();

            for (i = 0; i < N_SAMPLES; i = i + 1) begin
                sample = $random % 5000;
                @(posedge clk);
            end

            repeat(2) @(posedge clk);
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
        $display("goertzel_algorithm Testbench");
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
        input expected_detected;
        begin
            if (expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: detected=%b",
                         detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected=%b",
                         expected_detected);
                $display("  Got:      detected=%b",
                         detected);
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
        $dumpvars(0,clk, reset, sample, detected);
    end

endmodule
