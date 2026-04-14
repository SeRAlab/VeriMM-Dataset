`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg rst_n;
    wire [3:0] active_irq;
    wire irq_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .rst_n(rst_n),
        .active_irq(active_irq),
        .irq_ack(irq_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            irq = 4'b0000;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset Check", test_num);

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Single IRQ Asserted (Bit 0)", test_num);
            irq = 4'b0001;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Single IRQ Asserted (Bit 3)", test_num);
            irq = 4'b1000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple IRQs Asserted", test_num);
            irq = 4'b1011;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ Asserted then Cleared", test_num);


            irq = 4'b0100;
            repeat(2) @(posedge clk);


            irq = 4'b0000;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential IRQ Processing", test_num);


            irq = 4'b0010;
            repeat(2) @(posedge clk);


            irq = 4'b0000;
            repeat(1) @(posedge clk);
            irq = 4'b1000;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'b1000, 1'b1);
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
        input [3:0] expected_active_irq;
        input expected_irq_ack;
        begin
            if (expected_active_irq === (expected_active_irq ^ active_irq ^ expected_active_irq) &&
                expected_irq_ack === (expected_irq_ack ^ irq_ack ^ expected_irq_ack)) begin
                $display("PASS");
                $display("  Outputs: active_irq=%h, irq_ack=%b",
                         active_irq, irq_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_irq=%h, irq_ack=%b",
                         expected_active_irq, expected_irq_ack);
                $display("  Got:      active_irq=%h, irq_ack=%b",
                         active_irq, irq_ack);
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
        $dumpvars(0,clk, irq, rst_n, active_irq, irq_ack);
    end

endmodule
