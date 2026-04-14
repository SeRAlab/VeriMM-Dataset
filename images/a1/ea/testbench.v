`timescale 1ns/1ps

module debouncer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg noisy_in;
    reg rst_n;
    wire clean_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debouncer dut (
        .clk(clk),
        .noisy_in(noisy_in),
        .rst_n(rst_n),
        .clean_out(clean_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            noisy_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Valid High Pulse (Length > 65535)");
            reset_dut();
            noisy_in = 1;

            repeat (65535 + 10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Short Glitch (Length < 65535)");
            reset_dut();
            noisy_in = 1;

            repeat (30000) @(posedge clk);
            noisy_in = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Output goes low when input goes low");
            reset_dut();
            noisy_in = 1;
            repeat (65535 + 5) @(posedge clk);

            noisy_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Global Reset during High Output");
            reset_dut();
            noisy_in = 1;
            repeat (65535 + 5) @(posedge clk);

            rst_n = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Interrupted High Pulse (Counter Reset Check)");
            reset_dut();
            noisy_in = 1;
            repeat (60000) @(posedge clk);
            noisy_in = 0;
            @(posedge clk);
            noisy_in = 1;


            repeat (10000) @(posedge clk);
            #1;
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
        $dumpvars(0,clk, noisy_in, rst_n, clean_out);
    end

endmodule
