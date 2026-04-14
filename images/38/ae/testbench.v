`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg reset;
    wire [1:0] serviced_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .reset(reset),
        .serviced_irq(serviced_irq)
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single IRQ 0", test_num);
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single IRQ 3", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous IRQ 0 and 1 (Priority)", test_num);
            reset_dut();
            irq = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous IRQ 2 and 3 (Priority)", test_num);
            reset_dut();
            irq = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Non-preemption (IRQ 3 then IRQ 0)", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            irq = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Release and Switch", test_num);
            reset_dut();
            irq = 4'b0100;
            @(posedge clk);
            #1;
            irq = 4'b0000;
            @(posedge clk);
            #1;
            irq = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_serviced_irq;
        begin
            if (expected_serviced_irq === (expected_serviced_irq ^ serviced_irq ^ expected_serviced_irq)) begin
                $display("PASS");
                $display("  Outputs: serviced_irq=%h",
                         serviced_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serviced_irq=%h",
                         expected_serviced_irq);
                $display("  Got:      serviced_irq=%h",
                         serviced_irq);
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
        $dumpvars(0,clk, irq, reset, serviced_irq);
    end

endmodule
