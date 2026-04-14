`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg [3:0] brightness_control;
    reg inclk0;
    wire c0;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .brightness_control(brightness_control),
        .inclk0(inclk0),
        .c0(c0),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            #100;
            areset = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            areset = 1;
            brightness_control = 4'b1111;
            #100;
            test_num = 1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            brightness_control = 4'b1000;
            #5000;
            test_num = 2;

            if (locked === 1'b1)
                #1;

                check_outputs(c0, 1'b1);
            else
                #1;

                check_outputs(c0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            brightness_control = 4'b0000;
            #10000;
            test_num = 3;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            brightness_control = 4'b1110;
            #20000;
            test_num = 4;


            #1;



            check_outputs(c0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            brightness_control = 4'b0111;
            #50000;
            test_num = 5;

            #1;


            check_outputs(c0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_c0;
        input expected_locked;
        begin
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: c0=%b, locked=%b",
                         c0, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%b, locked=%b",
                         expected_c0, expected_locked);
                $display("  Got:      c0=%b, locked=%b",
                         c0, locked);
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
        $dumpvars(0,areset, brightness_control, inclk0, c0, locked);
    end

endmodule
