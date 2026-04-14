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

            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Counter Increment (50 cycles)", test_num);
            reset_dut();
            repeat(50) @(posedge clk);

            #1;


            check_outputs(32'd50, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Local Counter Reset Check", test_num);
            reset_dut();
            repeat(30) @(posedge clk);
            rst_counter = 1;
            @(posedge clk);
            rst_counter = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'd10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ym_pm Logic - Real Speed High", test_num);
            reset_dut();
            real_speed = 1;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'd20, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ym_pm Logic - UART Speed High", test_num);
            reset_dut();
            uart_speed = 1;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(32'd15, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ_N (Active Low) Signal Persistence", test_num);
            reset_dut();
            irq_n = 0;
            repeat(40) @(posedge clk);

            #1;


            check_outputs(32'd40, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Value Counter Test", test_num);
            reset_dut();
            repeat(1000) @(posedge clk);
            #1;

            check_outputs(32'd1000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Counter Reset and Speed Change", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            rst_counter = 1;
            real_speed = 1;
            @(posedge clk);
            rst_counter = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'd5, 1'b1);
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
