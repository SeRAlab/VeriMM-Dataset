`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gie;
    reg [3:0] irq;
    reg reset;
    wire [1:0] highest_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .gie(gie),
        .irq(irq),
        .reset(reset),
        .highest_irq(highest_irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            gie = 0;
            irq = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: System Reset and Default State");
            reset_dut();
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: GIE Disabled with all IRQs active (should output 0)");
            reset_dut();
            gie = 0;
            irq = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: IRQ0 only (Priority 0)");
            reset_dut();
            gie = 1;
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: IRQ1 only (Priority 1)");
            reset_dut();
            gie = 1;
            irq = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: IRQ2 only (Priority 2)");
            reset_dut();
            gie = 1;
            irq = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: IRQ3 only (Priority 3)");
            reset_dut();
            gie = 1;
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Multiple IRQs (IRQ0 and IRQ3), IRQ0 should win");
            reset_dut();
            gie = 1;
            irq = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase008: Multiple IRQs (IRQ1 and IRQ2), IRQ1 should win");
            reset_dut();
            gie = 1;
            irq = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase009: All IRQs active, IRQ0 should win");
            reset_dut();
            gie = 1;
            irq = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase010: Toggle GIE while IRQ2 is active");
            reset_dut();
            gie = 1;
            irq = 4'b0100;
            @(posedge clk);
            #1;
            $display("  GIE=1 check:");
            #1;

            check_outputs(2'd2);

            gie = 0;
            @(posedge clk);
            #1;
            $display("  GIE=0 check:");
            #1;

            check_outputs(2'd0);
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
        testcase010();
        
        
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
        input [1:0] expected_highest_irq;
        begin
            if (expected_highest_irq === (expected_highest_irq ^ highest_irq ^ expected_highest_irq)) begin
                $display("PASS");
                $display("  Outputs: highest_irq=%h",
                         highest_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: highest_irq=%h",
                         expected_highest_irq);
                $display("  Got:      highest_irq=%h",
                         highest_irq);
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
        $dumpvars(0,clk, gie, irq, reset, highest_irq);
    end

endmodule
