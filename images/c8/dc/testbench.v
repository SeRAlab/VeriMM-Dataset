`timescale 1ns/1ps

module dff_async_rst_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg en;
    reg rst;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_async_rst dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            d = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset logic");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 1 with en=1");
            reset_dut();
            @(posedge clk);
            d <= 1'b1;
            en <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load 0 with en=1");
            reset_dut();

            @(posedge clk);
            en <= 1'b1;
            d <= 1'b1;
            @(posedge clk);

            d <= 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: en=0 prevents loading 1");
            reset_dut();
            @(posedge clk);
            d <= 1'b1;
            en <= 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: en=0 holds previous value 1");
            reset_dut();

            @(posedge clk);
            en <= 1'b1;
            d <= 1'b1;
            @(posedge clk);

            en <= 1'b0;
            d <= 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous reset while q is 1");
            reset_dut();

            @(posedge clk);
            en <= 1'b1;
            d <= 1'b1;
            @(posedge clk);
            #2;

            #3;
            rst = 1'b1;
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
        $display("dff_async_rst Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, en, rst, q);
    end

endmodule
