`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    wire interrupt;
    wire [1:0] irq_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .interrupt(interrupt),
        .irq_vector(irq_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            irq = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Interrupts", test_num);
            reset_dut();
            irq = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: irq[0] active", test_num);
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: irq[3] active", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: irq[0] and irq[3] active (Priority Test)", test_num);
            reset_dut();
            irq = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: irq[1] and irq[2] active (Priority Test)", test_num);
            reset_dut();
            irq = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All irqs active", test_num);
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Priority Transition", test_num);
            reset_dut();
            irq = 4'b0100;
            @(posedge clk);
            #1;
            irq = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
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
        input expected_interrupt;
        input [1:0] expected_irq_vector;
        begin
            if (expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt) &&
                expected_irq_vector === (expected_irq_vector ^ irq_vector ^ expected_irq_vector)) begin
                $display("PASS");
                $display("  Outputs: interrupt=%b, irq_vector=%h",
                         interrupt, irq_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt=%b, irq_vector=%h",
                         expected_interrupt, expected_irq_vector);
                $display("  Got:      interrupt=%b, irq_vector=%h",
                         interrupt, irq_vector);
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
        $dumpvars(0,clk, irq, interrupt, irq_vector);
    end

endmodule
