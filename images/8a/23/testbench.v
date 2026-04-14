`timescale 1ns/1ps

module different_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg q;
    wire w;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    different_module dut (
        .clock(clock),
        .q(q),
        .w(w),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            q = 0;


            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001...");
            test_num = test_num + 1;
            reset_dut();

            q = 0; #5;

            q = 1; #5;

            q = 0; #5;

            q = 1; #5;

            q = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002...");
            test_num = test_num + 1;
            reset_dut();
            q = 0; #5;
            q = 1; #5;
            q = 0; #5;
            q = 1; #5;
            q = 0; #5;
            q = 1; #5;
            q = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003...");
            test_num = test_num + 1;
            reset_dut();
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004...");
            test_num = test_num + 1;
            reset_dut();
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005...");
            test_num = test_num + 1;
            reset_dut();
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1; #5;
            q = 0; #5; q = 1;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("different_module Testbench");
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
        input expected_w;
        input expected_z;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%b, z=%b",
                         w, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%b, z=%b",
                         expected_w, expected_z);
                $display("  Got:      w=%b, z=%b",
                         w, z);
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
        $dumpvars(0,clock, q, w, z);
    end

endmodule
