`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg global_enable;
    reg [3:0] irq;
    reg reset;
    wire [1:0] irq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .global_enable(global_enable),
        .irq(irq),
        .reset(reset),
        .irq_out(irq_out)
    );

    // Clock generation (10ns period)
    initial begin
        global_enable = 0;
        forever #5 global_enable = ~global_enable;
    end

        task reset_dut;

        begin
            reset = 1;
            irq = 4'b0000;

            @(posedge global_enable);
            #2;
            reset = 0;
            @(posedge global_enable);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check IRQ0 (Highest Priority)", test_num);
            reset_dut();
            irq = 4'b0001;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Check IRQ3 (Lowest Priority)", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Priority Check (IRQ0 and IRQ3 active)", test_num);
            reset_dut();
            irq = 4'b1001;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Priority Check (IRQ1 and IRQ2 active)", test_num);
            reset_dut();
            irq = 4'b0110;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential Servicing (IRQ0 then IRQ1)", test_num);
            reset_dut();
            irq = 4'b0011;
            @(posedge global_enable);
            #2;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Servicing (All IRQs active)", test_num);
            reset_dut();
            irq = 4'b1111;
            @(posedge global_enable);
            @(posedge global_enable);
            @(posedge global_enable);
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: New higher priority interrupt arrival", test_num);
            reset_dut();
            irq = 4'b1100;
            @(posedge global_enable);
            #2;
            irq = 4'b1101;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Reset clears serviced list", test_num);
            reset_dut();
            irq = 4'b0011;
            @(posedge global_enable);
            #2;
            reset = 1; #10; reset = 0;
            irq = 4'b0011;
            @(posedge global_enable);
            #2;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_irq_out;
        begin
            if (expected_irq_out === (expected_irq_out ^ irq_out ^ expected_irq_out)) begin
                $display("PASS");
                $display("  Outputs: irq_out=%h",
                         irq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_out=%h",
                         expected_irq_out);
                $display("  Got:      irq_out=%h",
                         irq_out);
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
        $dumpvars(0,global_enable, irq, reset, irq_out);
    end

endmodule
