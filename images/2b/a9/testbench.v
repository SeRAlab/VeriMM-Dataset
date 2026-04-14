`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] irq;
    wire [1:0] ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .irq(irq),
        .ack(ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            irq = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            irq = 4'b0001;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 001: Single IRQ0");
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            irq = 4'b1000;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 002: Single IRQ3");
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            irq = 4'b1001;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 003: Priority IRQ3 vs IRQ0");
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            irq = 4'b0110;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 004: Priority IRQ2 vs IRQ1");
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            irq = 4'b1111;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 005: All IRQs active (Expect highest 3)");
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            irq = 4'b0010;
            enable = 1;
            @(posedge clk);
            #2;
            $display("Testcase 006: Single IRQ1");
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            irq = 4'b0001;
            enable = 1;
            @(posedge clk);
            #1;
            irq = 4'b0100;
            @(posedge clk);
            #2;
            $display("Testcase 007: Sequential IRQ Change");
            #1;

            check_outputs(2'd2);
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
        input [1:0] expected_ack;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack)) begin
                $display("PASS");
                $display("  Outputs: ack=%h",
                         ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h",
                         expected_ack);
                $display("  Got:      ack=%h",
                         ack);
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
        $dumpvars(0,clk, enable, irq, ack);
    end

endmodule
