`timescale 1ns/1ps

module another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg n;
    wire m;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    another_module dut (
        .clock(clock),
        .n(n),
        .m(m),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            n = 0;

            @(negedge clock);
            #1; n = 0;
            @(posedge clock);
            #1; n = 0;
            @(negedge clock);
            #1; n = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clock); #1; n = 0;

            @(negedge clock); #1; n = 1;

            @(posedge clock); #1; n = 1;

            @(negedge clock); #1; n = 1;

            @(posedge clock); #1; n = 0;

            @(negedge clock); #1; n = 0;

            @(posedge clock); #1; n = 1;

            #2; #1;
 check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clock); #1; n = 1;
            @(negedge clock); #1; n = 1;
            @(posedge clock); #1; n = 1;
            @(negedge clock); #1; n = 1;
            @(posedge clock); #1; n = 1;

            #2; #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge clock); #1; n = 1;
            @(negedge clock); #1; n = 0;
            @(posedge clock); #1; n = 0;
            @(negedge clock); #1; n = 0;

            #2; #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge clock); #1; n = 1;
            @(negedge clock); #1; n = 1;
            @(posedge clock); #1; n = 1;
            @(negedge clock); #1; n = 0;
            @(posedge clock); #1; n = 0;

            #2; #1;
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
        $display("another_module Testbench");
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
        input expected_m;
        input expected_p;
        begin
            if (expected_m === (expected_m ^ m ^ expected_m) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: m=%b, p=%b",
                         m, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b, p=%b",
                         expected_m, expected_p);
                $display("  Got:      m=%b, p=%b",
                         m, p);
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
        $dumpvars(0,clock, n, m, p);
    end

endmodule
