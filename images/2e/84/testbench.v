`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hw_interrupt;
    reg sw_interrupt;
    wire interrupt_active;
    wire interrupt_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .hw_interrupt(hw_interrupt),
        .sw_interrupt(sw_interrupt),
        .interrupt_active(interrupt_active),
        .interrupt_type(interrupt_type)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            hw_interrupt = 0;
            sw_interrupt = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Hardware Interrupt", test_num);
            reset_dut();
            @(negedge clk);
            hw_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Software Interrupt", test_num);
            reset_dut();
            @(negedge clk);
            sw_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Simultaneous Interrupts (HW Priority)", test_num);
            reset_dut();
            @(negedge clk);
            hw_interrupt = 1;
            sw_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Ignore SW while HW Active", test_num);
            reset_dut();

            @(negedge clk);
            hw_interrupt = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            sw_interrupt = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Ignore HW while SW Active", test_num);
            reset_dut();

            @(negedge clk);
            sw_interrupt = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            hw_interrupt = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing Idle State (No Interrupts)", test_num);
            reset_dut();
            #2;
            #1;

            check_outputs(1'b0, interrupt_type);
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
        input expected_interrupt_active;
        input expected_interrupt_type;
        begin
            if (expected_interrupt_active === (expected_interrupt_active ^ interrupt_active ^ expected_interrupt_active) &&
                expected_interrupt_type === (expected_interrupt_type ^ interrupt_type ^ expected_interrupt_type)) begin
                $display("PASS");
                $display("  Outputs: interrupt_active=%b, interrupt_type=%b",
                         interrupt_active, interrupt_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_active=%b, interrupt_type=%b",
                         expected_interrupt_active, expected_interrupt_type);
                $display("  Got:      interrupt_active=%b, interrupt_type=%b",
                         interrupt_active, interrupt_type);
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
        $dumpvars(0,clk, hw_interrupt, sw_interrupt, interrupt_active, interrupt_type);
    end

endmodule
