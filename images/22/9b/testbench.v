`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] IRQ;
    reg RST;
    wire ACK;
    wire [3:0] current_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .CLK(CLK),
        .IRQ(IRQ),
        .RST(RST),
        .ACK(ACK),
        .current_irq(current_irq)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            IRQ = 4'b0000;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check...");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single IRQ (Bit 0)...");
            reset_dut();
            IRQ = 4'b0001;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single IRQ (Bit 3)...");
            reset_dut();
            IRQ = 4'b1000;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple simultaneous IRQs (Priority test)...");
            reset_dut();
            IRQ = 4'b1011;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Interrupt Latching/Persistence...");
            reset_dut();
            IRQ = 4'b0010;
            @(posedge CLK);
            #1;
            IRQ = 4'b0000;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'b0010);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset clearing active service...");
            reset_dut();
            IRQ = 4'b0100;
            @(posedge CLK);
            #1;
            RST = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Priority check (Bits 2 and 1)...");
            reset_dut();
            IRQ = 4'b0110;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 4'b0100);
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
        input expected_ACK;
        input [3:0] expected_current_irq;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK) &&
                expected_current_irq === (expected_current_irq ^ current_irq ^ expected_current_irq)) begin
                $display("PASS");
                $display("  Outputs: ACK=%b, current_irq=%h",
                         ACK, current_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%b, current_irq=%h",
                         expected_ACK, expected_current_irq);
                $display("  Got:      ACK=%b, current_irq=%h",
                         ACK, current_irq);
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
        $dumpvars(0,CLK, IRQ, RST, ACK, current_irq);
    end

endmodule
