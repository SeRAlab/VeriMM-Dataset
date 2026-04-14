`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq0;
    reg irq1;
    reg reset;
    wire [1:0] ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq0(irq0),
        .irq1(irq1),
        .reset(reset),
        .ack(ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        irq0 = 0;
        irq1 = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: No interrupts - ack should stay 00", test_num);
        reset_dut();
        irq0 = 0;
        irq1 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: IRQ0 asserted - ack should be 01 on next cycle", test_num);
        reset_dut();
        irq0 = 1;
        irq1 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: IRQ1 asserted - ack should be 10 on next cycle", test_num);
        reset_dut();
        irq0 = 0;
        irq1 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Simultaneous IRQ0 and IRQ1 - IRQ0 (01) has priority", test_num);
        reset_dut();
        irq0 = 1;
        irq1 = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset asserted during request - ack should be 00", test_num);
        reset_dut();
        irq0 = 1;
        irq1 = 1;
        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b00);
        reset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: IRQ1 then IRQ0 sequence", test_num);
        reset_dut();

        irq0 = 0; irq1 = 1;
        @(posedge clk);

        irq0 = 1; irq1 = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %03d: IRQ0 de-asserted", test_num);
        reset_dut();
        irq0 = 1;
        @(posedge clk);
        irq0 = 0;
        @(posedge clk);
        #1 #1;
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
        $dumpvars(0,clk, irq0, irq1, reset, ack);
    end

endmodule
