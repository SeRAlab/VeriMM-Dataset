`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    reg [3:0] irq;
    reg rst_n;
    wire int_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .irq(irq),
        .rst_n(rst_n),
        .int_active(int_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            clear = 0;
            enable = 0;
            irq = 4'b0000;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic IRQ0 check", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0001;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic IRQ3 check", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple IRQs active (IRQ3 and IRQ0)", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1001;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Disabled controller check", test_num);
            reset_dut();
            enable = 0;
            irq = 4'b1111;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Clear signal check", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0010;
            @(posedge clk);
            clear = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No IRQ active check", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0000;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable toggle during active IRQ", test_num);
            reset_dut();
            irq = 4'b0100;
            enable = 0;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hardware reset priority check", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1111;
            @(posedge clk);
            rst_n = 0;
            @(posedge clk);
            #2 #1;
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
        $display("interrupt_controller Testbench");
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
        input expected_int_active;
        begin
            if (expected_int_active === (expected_int_active ^ int_active ^ expected_int_active)) begin
                $display("PASS");
                $display("  Outputs: int_active=%b",
                         int_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_active=%b",
                         expected_int_active);
                $display("  Got:      int_active=%b",
                         int_active);
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
        $dumpvars(0,clear, clk, enable, irq, rst_n, int_active);
    end

endmodule
