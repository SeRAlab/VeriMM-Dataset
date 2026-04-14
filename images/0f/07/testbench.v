`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] irq;
    reg reset;
    wire [3:0] active_irq;
    wire interrupt_request;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .irq(irq),
        .reset(reset),
        .active_irq(active_irq),
        .interrupt_request(interrupt_request)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            irq = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single IRQ (IRQ0) active, enabled", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single IRQ active, disabled", test_num);
            reset_dut();
            enable = 0;
            irq = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple IRQs (IRQ1, IRQ3) active, enabled", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset overriding active IRQs", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1111;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All IRQs active, enabled", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggling enable with constant IRQ", test_num);
            reset_dut();
            irq = 4'b0100;
            enable = 0;
            @(posedge clk);

            enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100, 1'b1);
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
        input [3:0] expected_active_irq;
        input expected_interrupt_request;
        begin
            if (expected_active_irq === (expected_active_irq ^ active_irq ^ expected_active_irq) &&
                expected_interrupt_request === (expected_interrupt_request ^ interrupt_request ^ expected_interrupt_request)) begin
                $display("PASS");
                $display("  Outputs: active_irq=%h, interrupt_request=%b",
                         active_irq, interrupt_request);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_irq=%h, interrupt_request=%b",
                         expected_active_irq, expected_interrupt_request);
                $display("  Got:      active_irq=%h, interrupt_request=%b",
                         active_irq, interrupt_request);
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
        $dumpvars(0,clk, enable, irq, reset, active_irq, interrupt_request);
    end

endmodule
