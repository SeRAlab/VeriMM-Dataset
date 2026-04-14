`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_value;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            load_value = 4'b0000;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset to zero...");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Loading value 4'hF (15)...");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 4'hF;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Loading 4'hA (10) and decrementing 3 times...");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 4'hA;
            @(negedge clk);
            load = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Loading 4'h2 and counting down 2 steps to zero...");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 4'h2;
            @(negedge clk);
            load = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Checking wrap-around from 4'h0 to 4'hF...");
            reset_dut();

            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Verifying Reset priority over Load...");
            reset_dut();
            @(negedge clk);
            reset = 1;
            load = 1;
            load_value = 4'h5;
            @(negedge clk);
            reset = 0;
            load = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Loading 4'h5 and decrementing 6 times (passing through 0)...");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 4'h5;
            @(negedge clk);
            load = 0;
            repeat(6) @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_value, reset, count);
    end

endmodule
