`timescale 1ns/1ps

module my_clock_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;
    wire reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_clock dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out),
        .reset_out(reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(2) @(posedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset_out assertion delay (5 cycles)...", test_num);

            reset = 0;
            repeat(2) @(posedge clk_in);


            reset = 1;

            repeat(5) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking reset_out de-assertion delay (5 cycles)...", test_num);
            reset_dut();


            reset = 0;

            repeat(5) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking clock division after even number of cycles (10)...", test_num);
            reset_dut();
            reset = 0;

            repeat(10) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking clock division after odd number of cycles (11)...", test_num);
            reset_dut();
            reset = 0;

            repeat(11) @(posedge clk_in);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("my_clock Testbench");
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
        input expected_clk_out;
        input expected_reset_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_reset_out === (expected_reset_out ^ reset_out ^ expected_reset_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, reset_out=%b",
                         clk_out, reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, reset_out=%b",
                         expected_clk_out, expected_reset_out);
                $display("  Got:      clk_out=%b, reset_out=%b",
                         clk_out, reset_out);
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
        $dumpvars(0,clk_in, reset, clk_out, reset_out);
    end

endmodule
