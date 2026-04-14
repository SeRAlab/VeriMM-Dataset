`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg global_enable;
    reg [3:0] irq;
    reg reset;
    wire ack_signal;
    wire int_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .global_enable(global_enable),
        .irq(irq),
        .reset(reset),
        .ack_signal(ack_signal),
        .int_signal(int_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            global_enable = 0;
            irq = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No IRQ, Global Enable High", test_num);
            reset_dut();
            global_enable = 1;
            irq = 4'b0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: IRQ Present, Global Enable Low", test_num);
            reset_dut();
            global_enable = 0;
            irq = 4'b1111;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single IRQ bit 0, Global Enable High", test_num);
            reset_dut();
            global_enable = 1;
            irq = 4'b0001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single IRQ bit 3, Global Enable High", test_num);
            reset_dut();
            global_enable = 1;
            irq = 4'b1000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple IRQs (bit 1 and 2), Global Enable High", test_num);
            reset_dut();
            global_enable = 1;
            irq = 4'b0110;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during active IRQ", test_num);
            reset_dut();
            global_enable = 1;
            irq = 4'b1111;
            repeat(2) @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle Global Enable during active IRQ", test_num);
            reset_dut();
            irq = 4'b0011;
            global_enable = 1;
            repeat(2) @(posedge clk);
            global_enable = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_ack_signal;
        input expected_int_signal;
        begin
            if (expected_ack_signal === (expected_ack_signal ^ ack_signal ^ expected_ack_signal) &&
                expected_int_signal === (expected_int_signal ^ int_signal ^ expected_int_signal)) begin
                $display("PASS");
                $display("  Outputs: ack_signal=%b, int_signal=%b",
                         ack_signal, int_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_signal=%b, int_signal=%b",
                         expected_ack_signal, expected_int_signal);
                $display("  Got:      ack_signal=%b, int_signal=%b",
                         ack_signal, int_signal);
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
        $dumpvars(0,clk, global_enable, irq, reset, ack_signal, int_signal);
    end

endmodule
