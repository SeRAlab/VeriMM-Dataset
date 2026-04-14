`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clock;
    reg reset;
    reg signal;
    wire irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .clock(clock),
        .reset(reset),
        .signal(signal),
        .irq(irq)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            signal = 0;
            ack = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset condition");
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Rising edge detection");
            reset_dut();
            signal = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: IRQ persistence after signal falls");
            reset_dut();
            signal = 1;
            @(posedge clock);
            #1;
            signal = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Acknowledge functionality");
            reset_dut();
            signal = 1;
            @(posedge clock);
            #1;
            ack = 1;
            @(posedge clock);
            #1;
            ack = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple trigger events");
            reset_dut();

            signal = 1; @(posedge clock); #1;
            ack = 1; @(posedge clock); #1;
            ack = 0; signal = 0; @(posedge clock); #1;

            signal = 1; @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Signal high during reset (no transition check)");
            reset = 1; signal = 1; ack = 0;
            @(posedge clock); #1;
            reset = 0;
            @(posedge clock); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset clears asserted IRQ");
            reset_dut();
            signal = 1;
            @(posedge clock); #1;
            reset = 1;
            @(posedge clock); #1;
            reset = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Simultaneous edge and acknowledge");
            reset_dut();
            signal = 1;
            ack = 1;
            @(posedge clock);
            #1;
            ack = 0;
            @(posedge clock);
            #1;



            #1;




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
        input expected_irq;
        begin
            if (expected_irq === (expected_irq ^ irq ^ expected_irq)) begin
                $display("PASS");
                $display("  Outputs: irq=%b",
                         irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq=%b",
                         expected_irq);
                $display("  Got:      irq=%b",
                         irq);
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
        $dumpvars(0,ack, clock, reset, signal, irq);
    end

endmodule
