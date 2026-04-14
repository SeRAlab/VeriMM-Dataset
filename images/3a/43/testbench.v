`timescale 1ns/1ps

module goertzel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sample;
    wire detection_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    goertzel dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .detection_flag(detection_flag)
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
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Zero Input (Silence)", test_num);
            reset_dut();

            for (i = 0; i < SAMPLES_PER_BLOCK; i = i + 1) begin
                sample = 16'd0;
                @(posedge clk);
            end


            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        real target_freq;
        begin
            test_num = 2;
            target_freq = 1000.0;
            $display("Running testcase%03d: Target Frequency (%f Hz)", test_num, target_freq);
            reset_dut();

            for (i = 0; i < SAMPLES_PER_BLOCK; i = i + 1) begin


                sample = $rtoi(10000.0 * $sin(2.0 * PI * target_freq * i / SAMPLING_FREQ));
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        real wrong_freq;
        begin
            test_num = 3;
            wrong_freq = 400.0;
            $display("Running testcase%03d: Incorrect Frequency (%f Hz)", test_num, wrong_freq);
            reset_dut();

            for (i = 0; i < SAMPLES_PER_BLOCK; i = i + 1) begin
                sample = $rtoi(10000.0 * $sin(2.0 * PI * wrong_freq * i / SAMPLING_FREQ));
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: DC Offset (Max Constant)", test_num);
            reset_dut();

            for (i = 0; i < SAMPLES_PER_BLOCK; i = i + 1) begin
                sample = 16'h7FFF;
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
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
        $display("goertzel Testbench");
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
        input expected_detection_flag;
        begin
            if (expected_detection_flag === (expected_detection_flag ^ detection_flag ^ expected_detection_flag)) begin
                $display("PASS");
                $display("  Outputs: detection_flag=%b",
                         detection_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detection_flag=%b",
                         expected_detection_flag);
                $display("  Got:      detection_flag=%b",
                         detection_flag);
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
        $dumpvars(0,clk, reset, sample, detection_flag);
    end

endmodule
