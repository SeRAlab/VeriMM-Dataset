`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg t;
    wire o;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .t(t),
        .o(o),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            t = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: No toggle when t=0", test_num);
            t = 0;
            repeat (2) @(posedge clock);
            #1;




            #1;





            check_outputs(o, p);
        end
        endtask

    task testcase002;

        reg prev_o;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle 'o' once", test_num);
            prev_o = o;
            t = 1;
            @(posedge clock);
            #1;
            t = 0;
            #1;

            check_outputs(~prev_o, p);
        end
        endtask

    task testcase003;

        reg prev_p;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Two clock cycles with t=1", test_num);
            prev_p = p;
            t = 1;
            repeat (2) @(posedge clock);
            #1;
            t = 0;


            #1;



            check_outputs(o, ~prev_p);
        end
        endtask

    task testcase004;

        reg start_o, start_p;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Four clock cycles with t=1 (Rollover)", test_num);
            start_o = o;
            start_p = p;
            t = 1;
            repeat (4) @(posedge clock);
            #1;
            t = 0;

            #1;


            check_outputs(start_o, start_p);
        end
        endtask

    task testcase005;

        reg start_o;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Intermittent t pulses", test_num);
            start_o = o;
            t = 1; @(posedge clock); #1;
            t = 0; @(posedge clock); #1;
            t = 1; @(posedge clock); #1;
            t = 0;
            #1;

            check_outputs(start_o, p);
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
        input expected_o;
        input expected_p;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: o=%b, p=%b",
                         o, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b, p=%b",
                         expected_o, expected_p);
                $display("  Got:      o=%b, p=%b",
                         o, p);
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
        $dumpvars(0,clock, t, o, p);
    end

endmodule
