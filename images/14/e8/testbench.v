`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg irq0;
    reg irq1;
    reg irq2;
    reg irq3;
    wire ack0;
    wire ack1;
    wire ack2;
    wire ack3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq0(irq0),
        .irq1(irq1),
        .irq2(irq2),
        .irq3(irq3),
        .ack0(ack0),
        .ack1(ack1),
        .ack2(ack2),
        .ack3(ack3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            irq0 = 0;
            irq1 = 0;
            irq2 = 0;
            irq3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Highest Priority (irq0) only", test_num);
            irq0 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Lowest Priority (irq3) only", test_num);
            irq3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Conflict - irq0 and irq1 (irq0 should win)", test_num);
            irq0 = 1;
            irq1 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Conflict - irq1, irq2, irq3 (irq1 should win)", test_num);
            irq1 = 1;
            irq2 = 1;
            irq3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: All IRQs active (irq0 should win)", test_num);
            irq0 = 1;
            irq1 = 1;
            irq2 = 1;
            irq3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: No IRQs active", test_num);
            irq0 = 0;
            irq1 = 0;
            irq2 = 0;
            irq3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTestcase %0d: Middle Priority (irq2) only", test_num);
            irq2 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
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
        input expected_ack0;
        input expected_ack1;
        input expected_ack2;
        input expected_ack3;
        begin
            if (expected_ack0 === (expected_ack0 ^ ack0 ^ expected_ack0) &&
                expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_ack2 === (expected_ack2 ^ ack2 ^ expected_ack2) &&
                expected_ack3 === (expected_ack3 ^ ack3 ^ expected_ack3)) begin
                $display("PASS");
                $display("  Outputs: ack0=%b, ack1=%b, ack2=%b, ack3=%b",
                         ack0, ack1, ack2, ack3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack0=%b, ack1=%b, ack2=%b, ack3=%b",
                         expected_ack0, expected_ack1, expected_ack2, expected_ack3);
                $display("  Got:      ack0=%b, ack1=%b, ack2=%b, ack3=%b",
                         ack0, ack1, ack2, ack3);
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
        $dumpvars(0,clk, irq0, irq1, irq2, irq3, ack0, ack1, ack2, ack3);
    end

endmodule
