`timescale 1ns/1ps

module yet_another_new_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg q;
    wire p;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_another_new_module dut (
        .clock(clock),
        .q(q),
        .p(p),
        .r(r)
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
            test_num = test_num + 1;
            $display("Testcase %0d: q=0 at negedge -> r=1 at posedge", test_num);
            reset_dut();
            q = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: q=1 at negedge -> r=0 at posedge", test_num);
            reset_dut();
            q = 1;
            @(negedge clock);
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: falling edge check (p=0, r=1)", test_num);
            reset_dut();
            @(posedge clock);
            @(negedge clock);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full sequence matching waveform", test_num);

            q = 0;
            @(posedge clock);
            @(negedge clock); q = 1;
            @(posedge clock);
            @(negedge clock); q = 1;
            @(posedge clock);
            @(negedge clock); q = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("yet_another_new_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_p;
        input expected_r;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: p=%b, r=%b",
                         p, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b, r=%b",
                         expected_p, expected_r);
                $display("  Got:      p=%b, r=%b",
                         p, r);
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
        $dumpvars(0,clock, q, p, r);
    end

endmodule
