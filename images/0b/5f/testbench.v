`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] irq;
    wire [3:0] ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .enable(enable),
        .irq(irq),
        .ack(ack)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Controller disabled (enable=0), no IRQs", test_num);
        enable = 0;
        irq = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Controller disabled (enable=0), all IRQs active", test_num);
        enable = 0;
        irq = 4'b1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Controller enabled, no IRQs", test_num);
        enable = 1;
        irq = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single IRQ active (IRQ 0)", test_num);
        enable = 1;
        irq = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single IRQ active (IRQ 1)", test_num);
        enable = 1;
        irq = 4'b0010;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single IRQ active (IRQ 2)", test_num);
        enable = 1;
        irq = 4'b0100;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single IRQ active (IRQ 3)", test_num);
        enable = 1;
        irq = 4'b1000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple IRQs (3, 2, 0), IRQ 3 wins", test_num);
        enable = 1;
        irq = 4'b1101;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple IRQs (2, 1, 0), IRQ 2 wins", test_num);
        enable = 1;
        irq = 4'b0111;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple IRQs (1, 0), IRQ 1 wins", test_num);
        enable = 1;
        irq = 4'b0011;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All IRQs active, IRQ 3 wins", test_num);
        enable = 1;
        irq = 4'b1111;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transition from Enabled to Disabled during active IRQ", test_num);

        enable = 1;
        irq = 4'b1000;
        #5;

        enable = 0;
        #1;

        check_outputs(4'b0000);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_ack;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
