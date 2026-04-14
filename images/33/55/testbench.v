`timescale 1ns/1ps

module InterruptController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg rst;
    wire [3:0] irq_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    InterruptController dut (
        .clk(clk),
        .irq(irq),
        .rst(rst),
        .irq_ack(irq_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            irq = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single IRQ on bit 0");
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single IRQ on bit 3");
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple IRQs (3 and 0) - Priority Check");
            reset_dut();
            irq = 4'b1001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple IRQs (2 and 1) - Priority Check");
            reset_dut();
            irq = 4'b0110;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: No IRQ signals after reset");
            reset_dut();
            irq = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: All IRQ bits active");
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Dynamic IRQ change (Bit 1 then Bit 3)");
            reset_dut();
            irq = 4'b0010;
            @(posedge clk);
            #1;

            if (irq_ack !== 4'b0010) $display("Intermediate Step Fail");


            irq = 4'b1010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("InterruptController Testbench");
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
        input [3:0] expected_irq_ack;
        begin
            if (expected_irq_ack === (expected_irq_ack ^ irq_ack ^ expected_irq_ack)) begin
                $display("PASS");
                $display("  Outputs: irq_ack=%h",
                         irq_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_ack=%h",
                         expected_irq_ack);
                $display("  Got:      irq_ack=%h",
                         irq_ack);
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
        $dumpvars(0,clk, irq, rst, irq_ack);
    end

endmodule
