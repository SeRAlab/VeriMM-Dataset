`timescale 1ns/1ps

module counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg en;
    reg load;
    reg rst_n;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_4bit dut (
        .clk(clk),
        .d(d),
        .en(en),
        .load(load),
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
            @(negedge clk);
            rst_n = 0;
            en = 0;
            load = 0;
            d = 4'b0000;
            @(negedge clk);
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset check");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Synchronous Load check");
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 4'hA;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Basic Counting check");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(3) @(negedge clk);

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Enable Disable check");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Load Priority check");
            reset_dut();
            @(negedge clk);
            en = 1;
            load = 1;
            d = 4'h5;
            @(negedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Wrap-around check");
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 4'hF;
            @(negedge clk);
            load = 0;
            en = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Increment from loaded value");
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 4'h7;
            @(negedge clk);
            load = 0;
            en = 1;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(4'h9);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, en, load, rst_n, q);
    end

endmodule
