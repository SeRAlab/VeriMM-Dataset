`timescale 1ns/1ps

module counter_updown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg en;
    reg rst_n;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_updown dut (
        .clk(clk),
        .dir(dir),
        .en(en),
        .rst_n(rst_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            dir = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Up Counting (10 cycles)");
            reset_dut();
            en = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Basic Down Counting (from 0)");
            reset_dut();
            en = 1;
            dir = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Enable Signal (counting then pausing)");
            reset_dut();
            en = 1;
            dir = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Overflow Check");
            reset_dut();
            en = 1;
            dir = 1;
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Underflow Check");
            reset_dut();
            en = 1;
            dir = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Direction Switching (Up 10, Down 4)");
            reset_dut();
            en = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            dir = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Complex Enable/Direction Sequence");
            reset_dut();
            en = 1; dir = 1;
            repeat(20) @(posedge clk);
            en = 0; dir = 0;
            repeat(10) @(posedge clk);
            en = 1; dir = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_updown Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, dir, en, rst_n, q);
    end

endmodule
