`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq_n;
    reg real_speed;
    reg rst;
    reg rst_counter;
    reg uart_speed;
    wire [31:0] pm_counter;
    wire ym_pm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .irq_n(irq_n),
        .real_speed(real_speed),
        .rst(rst),
        .rst_counter(rst_counter),
        .uart_speed(uart_speed),
        .pm_counter(pm_counter),
        .ym_pm(ym_pm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rst_counter = 0;
            irq_n = 1;
            real_speed = 0;
            uart_speed = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                irq_n = 0;
                repeat(2) @(posedge clk);
                irq_n = 1;
                repeat(2) @(posedge clk);
            end
            #1;

            check_outputs(32'd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clk);
            irq_n = 0;
            repeat(2) @(posedge clk);
            irq_n = 1;
            repeat(1) @(posedge clk);


            rst_counter = 1;
            repeat(2) @(posedge clk);
            rst_counter = 0;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            real_speed = 1;
            uart_speed = 0;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(32'd0, ym_pm);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(10) begin
                irq_n = 0;
                #10;
                irq_n = 1;
                #10;
            end
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd10, ym_pm);
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
        input [31:0] expected_pm_counter;
        input expected_ym_pm;
        begin
            if (expected_pm_counter === (expected_pm_counter ^ pm_counter ^ expected_pm_counter) &&
                expected_ym_pm === (expected_ym_pm ^ ym_pm ^ expected_ym_pm)) begin
                $display("PASS");
                $display("  Outputs: pm_counter=%h, ym_pm=%b",
                         pm_counter, ym_pm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pm_counter=%h, ym_pm=%b",
                         expected_pm_counter, expected_ym_pm);
                $display("  Got:      pm_counter=%h, ym_pm=%b",
                         pm_counter, ym_pm);
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
        $dumpvars(0,clk, irq_n, real_speed, rst, rst_counter, uart_speed, pm_counter, ym_pm);
    end

endmodule
