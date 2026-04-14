`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] irq;
    wire [1:0] highest_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .irq(irq),
        .highest_irq(highest_irq)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No IRQs active (Idle)", test_num);
            irq = 4'b0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Only IRQ0 active", test_num);
            irq = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only IRQ1 active", test_num);
            irq = 4'b0010;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only IRQ2 active", test_num);
            irq = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Only IRQ3 active", test_num);
            irq = 4'b1000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple IRQs (0 and 1 active), IRQ0 wins", test_num);
            irq = 4'b0011;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple IRQs (1 and 3 active), IRQ1 wins", test_num);
            irq = 4'b1010;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple IRQs (2 and 3 active), IRQ2 wins", test_num);
            irq = 4'b1100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: All IRQs active, IRQ0 wins", test_num);
            irq = 4'b1111;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Multiple IRQs (1, 2, and 3 active), IRQ1 wins", test_num);
            irq = 4'b1110;
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_highest_irq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_highest_irq === (expected_highest_irq ^ highest_irq ^ expected_highest_irq)) begin
                $display("PASS");
                $display("  Outputs: highest_irq=%h",
                         highest_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: highest_irq=%h",
                         expected_highest_irq);
                $display("  Got:      highest_irq=%h",
                         highest_irq);
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
