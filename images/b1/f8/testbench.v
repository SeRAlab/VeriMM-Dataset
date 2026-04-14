`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg reset;
    reg wr;
    wire [31:0] data_out;
    wire irq;
    wire wt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .reset(reset),
        .wr(wr),
        .data_out(data_out),
        .irq(irq),
        .wt(wt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            wr = 0;
            addr = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            addr = 2'h2;
            en = 1;
            wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 0);
            en = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            addr = 2'h1; data_in = 32'd10; en = 1; wr = 1;
            @(posedge clk);

            addr = 2'h0; data_in = 32'h1; en = 1; wr = 1;
            @(posedge clk);
            en = 0; wr = 0;

            repeat(12) @(posedge clk);

            #1;
            #1;

            check_outputs(data_out, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            addr = 2'h1; data_in = 32'd5; en = 1; wr = 1;
            @(posedge clk);

            addr = 2'h0; data_in = 32'h3; en = 1; wr = 1;
            @(posedge clk);
            en = 0; wr = 0;

            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(data_out, 1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr = 2'h1; data_in = 32'd20; en = 1; wr = 1;
            @(posedge clk);

            addr = 2'h0; data_in = 32'h1; en = 1; wr = 1;
            @(posedge clk);
            en = 0; wr = 0;

            repeat(5) @(posedge clk);

            addr = 2'h2; en = 1; wr = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd15, 0, 0);
            en = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            addr = 2'h1; data_in = 32'hAAAA_BBBB; en = 1; wr = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(data_in, 0, 1);
            en = 0; wr = 0;
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
        input [31:0] expected_data_out;
        input expected_irq;
        input expected_wt;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_wt === (expected_wt ^ wt ^ expected_wt)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, irq=%b, wt=%b",
                         data_out, irq, wt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, irq=%b, wt=%b",
                         expected_data_out, expected_irq, expected_wt);
                $display("  Got:      data_out=%h, irq=%b, wt=%b",
                         data_out, irq, wt);
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
        $dumpvars(0,addr, clk, data_in, en, reset, wr, data_out, irq, wt);
    end

endmodule
