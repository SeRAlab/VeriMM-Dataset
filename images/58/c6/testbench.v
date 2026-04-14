`timescale 1ns/1ps

module new_module_7_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg p;
    wire q;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_7 dut (
        .clock(clock),
        .p(p),
        .q(q),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            p = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: 2 cycles, expect q=1, r=1");
            reset_dut();
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(negedge clock);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: 3 cycles, expect q=0, r=1");
            reset_dut();
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(negedge clock);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: 4 cycles, expect q=1, r=0");
            reset_dut();
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(negedge clock);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: 5 cycles, expect q=0, r=1");
            reset_dut();
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(negedge clock);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: 6 cycles, expect q=1, r=0");
            reset_dut();
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(posedge clock) p = 1;
            @(negedge clock);
            #1;

            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_7 Testbench");
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
        input expected_q;
        input expected_r;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%b, r=%b",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, r=%b",
                         expected_q, expected_r);
                $display("  Got:      q=%b, r=%b",
                         q, r);
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
        $dumpvars(0,clock, p, q, r);
    end

endmodule
