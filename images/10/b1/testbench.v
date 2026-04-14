`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq0;
    reg irq1;
    reg irq2;
    reg irq3;
    reg rst_n;
    wire interrupt_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq0(irq0),
        .irq1(irq1),
        .irq2(irq2),
        .irq3(irq3),
        .rst_n(rst_n),
        .interrupt_out(interrupt_out)
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
            irq0 = 0;
            irq1 = 0;
            irq2 = 0;
            irq3 = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle state (all IRQs low)", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IRQ0 only", test_num);
            reset_dut();
            irq0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IRQ1 only", test_num);
            reset_dut();
            irq1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IRQ2 only", test_num);
            reset_dut();
            irq2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IRQ3 only", test_num);
            reset_dut();
            irq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous IRQ0 and IRQ3", test_num);
            reset_dut();
            irq0 = 1;
            irq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous IRQ1 and IRQ2", test_num);
            reset_dut();
            irq1 = 1;
            irq2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All IRQs active", test_num);
            reset_dut();
            irq0 = 1; irq1 = 1; irq2 = 1; irq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during active IRQ", test_num);
            reset_dut();
            irq0 = 1;
            @(posedge clk);
            #1;
            rst_n = 0;
            #2;
            #1;

            check_outputs(0);
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
        testcase009();
        
        
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
        input expected_interrupt_out;
        begin
            if (expected_interrupt_out === (expected_interrupt_out ^ interrupt_out ^ expected_interrupt_out)) begin
                $display("PASS");
                $display("  Outputs: interrupt_out=%b",
                         interrupt_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_out=%b",
                         expected_interrupt_out);
                $display("  Got:      interrupt_out=%b",
                         interrupt_out);
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
        $dumpvars(0,clk, irq0, irq1, irq2, irq3, rst_n, interrupt_out);
    end

endmodule
