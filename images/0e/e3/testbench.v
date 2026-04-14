`timescale 1ns/1ps

module goertzel_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] sample;
    reg start;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    goertzel dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .start(start),
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
            start = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Silence (Zero Input)");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 64; i = i + 1) begin
                sample = 16'h0000;
                @(posedge clk);
            end


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        reg [15:0] sine_wave [0:63];
        begin
            $display("Running Testcase 002: Target Frequency Present");


            for (i = 0; i < 64; i = i + 1) begin

                if (i % 4 == 0) sine_wave[i] = 16'h7FFF;
                else if (i % 4 == 2) sine_wave[i] = 16'h8001;
                else sine_wave[i] = 16'h0000;
            end

            reset_dut();
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 64; i = i + 1) begin
                sample = sine_wave[i];
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Non-matching High Frequency");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 64; i = i + 1) begin

                sample = (i % 2 == 0) ? 16'h2000 : 16'hE000;
                @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: DC Offset");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 64; i = i + 1) begin
                sample = 16'h1000;
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
        $dumpvars(0,clk, reset, sample, start, detected);
    end

endmodule
