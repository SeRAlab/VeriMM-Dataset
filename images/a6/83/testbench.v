`timescale 1ns/1ps

module counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg En;
    reg clk;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_4bit dut (
        .En(En),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            En = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset Check");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Increment (En=1 for 1 cycle)");
            reset_dut();
            En = 1;
            @(posedge clk);
            #1;
            En = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Multiple Increments (En=1 for 5 cycles)");
            reset_dut();
            En = 1;
            repeat(5) @(posedge clk);
            #1;
            En = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Gating (3 ON, 2 OFF)");
            reset_dut();
            En = 1;
            repeat(3) @(posedge clk);
            En = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Rollover Check (16 cycles)");
            reset_dut();
            En = 1;
            repeat(16) @(posedge clk);
            #1;
            En = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Max Value Check (15 cycles)");
            reset_dut();
            En = 1;
            repeat(15) @(posedge clk);
            #1;
            En = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Intermittent Enable");
            reset_dut();
            En = 1; @(posedge clk);
            En = 0; @(posedge clk);
            En = 1; @(posedge clk);
            En = 0; @(posedge clk);
            En = 1; @(posedge clk);
            #1;
            En = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_4bit Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,En, clk, reset, Q);
    end

endmodule
