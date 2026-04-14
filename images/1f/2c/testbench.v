`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq0;
    reg irq1;
    reg rst;
    wire [1:0] active_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq0(irq0),
        .irq1(irq1),
        .rst(rst),
        .active_irq(active_irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        irq0 = 0;
        irq1 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial state after reset", test_num);
        reset_dut();
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IRQ0 high", test_num);
        reset_dut();
        irq0 = 1;
        irq1 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: IRQ1 high", test_num);
        reset_dut();
        irq0 = 0;
        irq1 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both IRQ0 and IRQ1 high", test_num);
        reset_dut();
        irq0 = 1;
        irq1 = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset priority over active IRQs", test_num);
        reset_dut();

        irq0 = 1;
        irq1 = 1;
        @(posedge clk);

        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Deasserting IRQ lines", test_num);
        reset_dut();
        irq0 = 1;
        @(posedge clk);
        irq0 = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
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
        input [1:0] expected_active_irq;
        begin
            if (expected_active_irq === (expected_active_irq ^ active_irq ^ expected_active_irq)) begin
                $display("PASS");
                $display("  Outputs: active_irq=%h",
                         active_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_irq=%h",
                         expected_active_irq);
                $display("  Got:      active_irq=%h",
                         active_irq);
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
        $dumpvars(0,clk, irq0, irq1, rst, active_irq);
    end

endmodule
