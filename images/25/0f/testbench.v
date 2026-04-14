`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg high_priority_interrupt;
    reg low_priority_interrupt;
    reg reset;
    wire interrupt_serviced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .high_priority_interrupt(high_priority_interrupt),
        .low_priority_interrupt(low_priority_interrupt),
        .reset(reset),
        .interrupt_serviced(interrupt_serviced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            high_priority_interrupt = 0;
            low_priority_interrupt = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: High Priority Interrupt", test_num);
            reset_dut();
            high_priority_interrupt = 1;
            low_priority_interrupt = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Low Priority Interrupt", test_num);
            reset_dut();
            high_priority_interrupt = 0;
            low_priority_interrupt = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Simultaneous Interrupts", test_num);
            reset_dut();
            high_priority_interrupt = 1;
            low_priority_interrupt = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: No Interrupts Active", test_num);
            reset_dut();
            high_priority_interrupt = 0;
            low_priority_interrupt = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Transition HP to LP", test_num);
            reset_dut();
            high_priority_interrupt = 1;
            low_priority_interrupt = 1;
            @(posedge clk);
            #1;
            high_priority_interrupt = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Reset during service", test_num);
            reset_dut();
            high_priority_interrupt = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
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
        input expected_interrupt_serviced;
        begin
            if (expected_interrupt_serviced === (expected_interrupt_serviced ^ interrupt_serviced ^ expected_interrupt_serviced)) begin
                $display("PASS");
                $display("  Outputs: interrupt_serviced=%b",
                         interrupt_serviced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_serviced=%b",
                         expected_interrupt_serviced);
                $display("  Got:      interrupt_serviced=%b",
                         interrupt_serviced);
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
        $dumpvars(0,clk, high_priority_interrupt, low_priority_interrupt, reset, interrupt_serviced);
    end

endmodule
