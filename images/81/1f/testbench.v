`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg resume_n;
    wire [13:0] random;
    wire rnd_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .resume_n(resume_n),
        .random(random),
        .rnd_ready(rnd_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            resume_n = 1;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Behavior Check");
            reset_n = 0;
            resume_n = 1;
            #20;
            #1;

            check_outputs(random, 0);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            $display("\nRunning Testcase 002: Range Validation [1000-5000]");
            reset_dut();
            resume_n = 1;
            timeout = 0;


            while (rnd_ready === 0 && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            if (rnd_ready === 1) begin
                if (random >= 1000 && random <= 5000) begin
                    $display("Success: Found random value %d in range.", random);
                    #1;

                    check_outputs(random, 1);
                end else begin
                    $display("Fail: Found value %d out of range while ready.", random);
                    fail_count = fail_count + 1;
                end
            end else begin
                $display("Fail: rnd_ready timed out.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [13:0] capture_val;
        begin
            $display("\nRunning Testcase 003: Pause Control (resume_n)");
            reset_dut();
            resume_n = 1;


            repeat(10) @(posedge clk);


            #1 resume_n = 0;
            repeat(2) @(posedge clk);
            capture_val = random;


            repeat(10) @(posedge clk);

            if (random === capture_val) begin
                $display("Success: Output held constant during resume_n=0.");
                pass_count = pass_count + 1;
            end else begin
                $display("Fail: Output changed while paused. Prev: %d, Now: %d", capture_val, random);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [13:0] first_val;
        integer timeout;
        begin
            $display("\nRunning Testcase 004: Consecutive Value Search");
            reset_dut();
            resume_n = 1;
            timeout = 0;


            while (rnd_ready === 0 && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            first_val = random;
            $display("First value found: %d", first_val);


            #1 resume_n = 0;
            @(posedge clk);
            #1 resume_n = 1;


            @(posedge clk);

            timeout = 0;
            while (rnd_ready === 0 && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            if (rnd_ready === 1 && random >= 1000 && random <= 5000) begin
                $display("Second value found: %d", random);
                pass_count = pass_count + 1;
            end else begin
                $display("Fail: Could not find second valid value.");
                fail_count = fail_count + 1;
            end
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
        input [13:0] expected_random;
        input expected_rnd_ready;
        begin
            if (expected_random === (expected_random ^ random ^ expected_random) &&
                expected_rnd_ready === (expected_rnd_ready ^ rnd_ready ^ expected_rnd_ready)) begin
                $display("PASS");
                $display("  Outputs: random=%h, rnd_ready=%b",
                         random, rnd_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random=%h, rnd_ready=%b",
                         expected_random, expected_rnd_ready);
                $display("  Got:      random=%h, rnd_ready=%b",
                         random, rnd_ready);
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
        $dumpvars(0,clk, reset_n, resume_n, random, rnd_ready);
    end

endmodule
