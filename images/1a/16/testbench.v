`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] int_ack;
    reg [3:0] irq;
    reg reset;
    wire int_out;
    wire [3:0] int_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .int_ack(int_ack),
        .irq(irq),
        .reset(reset),
        .int_out(int_out),
        .int_status(int_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            irq = 4'b0000;
            int_ack = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Interrupt (IRQ0)");
            test_num = 2;
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiple Interrupts (IRQ1, IRQ3)");
            test_num = 3;
            reset_dut();
            irq = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear Single Interrupt (IRQ2)");
            test_num = 4;
            reset_dut();

            irq = 4'b0100;
            @(posedge clk);
            #1;

            int_ack = 2'd2;
            irq = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Clear One of Multiple Interrupts");
            test_num = 5;
            reset_dut();

            irq = 4'b1001;
            @(posedge clk);
            #1;

            int_ack = 2'd0;
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential Acknowledge All");
            test_num = 6;
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            #1;


            int_ack = 2'd0; irq = 4'b1110; @(posedge clk); #1;

            int_ack = 2'd1; irq = 4'b1100; @(posedge clk); #1;

            int_ack = 2'd2; irq = 4'b1000; @(posedge clk); #1;

            int_ack = 2'd3; irq = 4'b0000; @(posedge clk); #1;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single Interrupt (IRQ3)");
            test_num = 7;
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1000);
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
        input expected_int_out;
        input [3:0] expected_int_status;
        begin
            if (expected_int_out === (expected_int_out ^ int_out ^ expected_int_out) &&
                expected_int_status === (expected_int_status ^ int_status ^ expected_int_status)) begin
                $display("PASS");
                $display("  Outputs: int_out=%b, int_status=%h",
                         int_out, int_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_out=%b, int_status=%h",
                         expected_int_out, expected_int_status);
                $display("  Got:      int_out=%b, int_status=%h",
                         int_out, int_status);
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
        $dumpvars(0,clk, int_ack, irq, reset, int_out, int_status);
    end

endmodule
