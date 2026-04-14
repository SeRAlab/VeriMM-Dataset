`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] irq;
    reg rst;
    wire [1:0] irq_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
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
            ack = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Single IRQ0");
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single IRQ3");
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Priority check IRQ0 vs IRQ2");
            reset_dut();
            irq = 4'b0101;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Priority check IRQ1 vs IRQ3");
            reset_dut();
            irq = 4'b1010;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Clear IRQ0, expect IRQ1");
            reset_dut();
            irq = 4'b0011;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);

            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential clear IRQ0, IRQ1, IRQ2 to see IRQ3");
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);


            ack = 1; @(posedge clk); ack = 0; @(posedge clk);

            ack = 1; @(posedge clk); ack = 0; @(posedge clk);

            ack = 1; @(posedge clk); ack = 0; @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Interleaved request and acknowledge");
            reset_dut();
            irq = 4'b0010;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);

            ack = 1; @(posedge clk); ack = 0;

            irq = 4'b0100;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);

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
        input [1:0] expected_irq_ack;
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
        $dumpvars(0,ack, clk, irq, rst, irq_ack);
    end

endmodule
