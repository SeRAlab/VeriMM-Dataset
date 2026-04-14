`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg reset;
    wire ack;
    wire [1:0] current_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .reset(reset),
        .ack(ack),
        .current_irq(current_irq)
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
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset and Idle Check", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IRQ 0 Assertion", test_num);
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: IRQ 1 Assertion", test_num);
            reset_dut();
            irq = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: IRQ 3 Assertion", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Priority Check (IRQ 0 vs IRQ 3)", test_num);
            reset_dut();
            irq = 4'b1001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority Check (IRQ 1 vs IRQ 2)", test_num);
            reset_dut();
            irq = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: All IRQs active simultaneously", test_num);
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: IRQ Cleared Check", test_num);
            reset_dut();
            irq = 4'b0100;
            @(posedge clk);
            irq = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 2'b00);
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
        input expected_ack;
        input [1:0] expected_current_irq;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_current_irq === (expected_current_irq ^ current_irq ^ expected_current_irq)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, current_irq=%h",
                         ack, current_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, current_irq=%h",
                         expected_ack, expected_current_irq);
                $display("  Got:      ack=%b, current_irq=%h",
                         ack, current_irq);
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
        $dumpvars(0,clk, irq, reset, ack, current_irq);
    end

endmodule
