`timescale 1ns/1ps

module avr_io_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] io_a;
    reg [7:0] io_di;
    reg io_re;
    reg io_we;
    reg rst;
    wire [7:0] io_do;
    wire irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    avr_io_timer dut (
        .clk(clk),
        .io_a(io_a),
        .io_di(io_di),
        .io_re(io_re),
        .io_we(io_we),
        .rst(rst),
        .io_do(io_do),
        .irq(irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("avr_io_timer Testbench");
        $display("========================================");


        
        
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
        input [7:0] expected_io_do;
        input expected_irq;
        begin
            if (expected_io_do === (expected_io_do ^ io_do ^ expected_io_do) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq)) begin
                $display("PASS");
                $display("  Outputs: io_do=%h, irq=%b",
                         io_do, irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_do=%h, irq=%b",
                         expected_io_do, expected_irq);
                $display("  Got:      io_do=%h, irq=%b",
                         io_do, irq);
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
        $dumpvars(0,clk, io_a, io_di, io_re, io_we, rst, io_do, irq);
    end

endmodule
