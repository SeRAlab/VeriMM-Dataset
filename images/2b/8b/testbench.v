`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq1;
    reg irq2;
    reg mask;
    wire [1:0] output_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq1(irq1),
        .irq2(irq2),
        .mask(mask),
        .output_irq(output_irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            irq1 = 0;
            irq2 = 0;
            mask = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            irq1 = 0;
            irq2 = 0;
            mask = 0;
            @(posedge clk);
            #2;
            $display("Test 001: No IRQ");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            irq1 = 1;
            mask = 0;
            #2;
            $display("Test 002: NMI (irq1) immediate response");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            irq1 = 1;
            mask = 1;
            #2;
            $display("Test 003: NMI (irq1) ignores mask");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            irq2 = 1;
            mask = 0;
            #2;


            @(posedge clk);
            #2;
            $display("Test 004: MI (irq2) serviced on next clock");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            irq2 = 1;
            mask = 1;
            @(posedge clk);
            #2;
            $display("Test 005: MI (irq2) ignored due to mask");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            irq1 = 1;
            irq2 = 1;
            mask = 0;
            #2;
            $display("Test 006: Simultaneous IRQs - NMI Priority");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            irq1 = 1;
            irq2 = 1;
            mask = 0;
            #2;
            irq1 = 0;
            @(posedge clk);
            #2;
            $display("Test 007: Sequential servicing - MI after NMI released");
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_output_irq;
        begin
            if (expected_output_irq === (expected_output_irq ^ output_irq ^ expected_output_irq)) begin
                $display("PASS");
                $display("  Outputs: output_irq=%h",
                         output_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_irq=%h",
                         expected_output_irq);
                $display("  Got:      output_irq=%h",
                         output_irq);
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
        $dumpvars(0,clk, irq1, irq2, mask, output_irq);
    end

endmodule
