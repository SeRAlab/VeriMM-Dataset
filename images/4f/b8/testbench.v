`timescale 1ns/1ps

module debouncer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg noisy_in;
    reg reset;
    wire clean_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debouncer dut (
        .clk(clk),
        .noisy_in(noisy_in),
        .reset(reset),
        .clean_out(clean_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            noisy_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: High Signal Propagation");
            reset_dut();
            @(posedge clk);
            noisy_in = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Low Signal Propagation");
            reset_dut();

            @(posedge clk);
            noisy_in = 1;
            repeat(3) @(posedge clk);


            @(posedge clk);
            noisy_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Synchronous Reset during High Input");
            reset_dut();
            @(posedge clk);
            noisy_in = 1;
            repeat(2) @(posedge clk);

            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 1-Cycle Delay Verification");
            reset_dut();
            @(posedge clk);
            noisy_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 1-Cycle Glitch Propagation");
            reset_dut();
            @(posedge clk);
            noisy_in = 1;
            @(posedge clk);
            noisy_in = 0;
            @(posedge clk);
            #1;
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
        $display("debouncer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_clean_out;
        begin
            if (expected_clean_out === (expected_clean_out ^ clean_out ^ expected_clean_out)) begin
                $display("PASS");
                $display("  Outputs: clean_out=%b",
                         clean_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_out=%b",
                         expected_clean_out);
                $display("  Got:      clean_out=%b",
                         clean_out);
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
        $dumpvars(0,clk, noisy_in, reset, clean_out);
    end

endmodule
