`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg [1:0] prty;
    reg rst;
    wire ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .prty(prty),
        .rst(rst),
        .ack(ack)
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
            prty = 2'b00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Initial state after reset (No IRQ)", test_num);
            reset_dut();
            irq = 4'b0000;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single IRQ[0] with Priority 0", test_num);
            reset_dut();
            irq = 4'b0001;
            prty = 2'b00;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single IRQ[3] with Priority 3", test_num);
            reset_dut();
            irq = 4'b1000;
            prty = 2'b11;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multiple simultaneous IRQs", test_num);
            reset_dut();
            irq = 4'b1011;
            prty = 2'b01;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: System reset during active service", test_num);
            reset_dut();
            irq = 4'b0010;
            prty = 2'b00;
            repeat(2) @(posedge clk);

            if (ack === 1'b1) begin
                rst = 1;
                repeat(2) @(posedge clk);
                #1 #1;
 check_outputs(1'b0);
            end else begin
                $display("  Skipping Reset check: Ack did not trigger.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Priority change without IRQ", test_num);
            reset_dut();
            irq = 4'b0000;
            prty = 2'b10;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_ack;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack)) begin
                $display("PASS");
                $display("  Outputs: ack=%b",
                         ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b",
                         expected_ack);
                $display("  Got:      ack=%b",
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
        $dumpvars(0,clk, irq, prty, rst, ack);
    end

endmodule
