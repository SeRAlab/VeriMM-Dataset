`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] irq;
    reg rst;
    wire irq_out;
    wire [1:0] irq_served;

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
        .irq_out(irq_out),
        .irq_served(irq_served)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            irq = 0;
            ack = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: System Idle after Reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Interrupt Request (IRQ0)");
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Priority Check (IRQ0 higher than IRQ3)");
            reset_dut();
            irq = 4'b1001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition to next pending interrupt after ACK");
            reset_dut();
            irq = 4'b0110;
            @(posedge clk);
            #1;

            ack = 1;
            irq = 4'b0100;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full sequence (IRQ1 -> ACK -> IRQ3 -> ACK -> Idle)");
            reset_dut();
            irq = 4'b1010;
            @(posedge clk);
            #1;

            ack = 1;
            irq = 4'b1000;
            @(posedge clk);
            #1;

            ack = 1;
            irq = 4'b0000;
            @(posedge clk);
            #1;

            ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'bxx);

            if (irq_out === 1'b0) begin
                 pass_count = pass_count + 1;
                 $display("PASS: System returned to Idle");
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: System did not return to Idle");
            end
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High priority arrival during low priority service");
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;

            irq = 4'b1011;
            @(posedge clk);
            #1;

            ack = 1;
            @(posedge clk);
            #1;

            ack = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single request on IRQ3");
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'd3);
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
        input expected_irq_out;
        input [1:0] expected_irq_served;
        begin
            if (expected_irq_out === (expected_irq_out ^ irq_out ^ expected_irq_out) &&
                expected_irq_served === (expected_irq_served ^ irq_served ^ expected_irq_served)) begin
                $display("PASS");
                $display("  Outputs: irq_out=%b, irq_served=%h",
                         irq_out, irq_served);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_out=%b, irq_served=%h",
                         expected_irq_out, expected_irq_served);
                $display("  Got:      irq_out=%b, irq_served=%h",
                         irq_out, irq_served);
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
        $dumpvars(0,ack, clk, irq, rst, irq_out, irq_served);
    end

endmodule
