`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in_domain;
    reg clk_out_domain;
    reg start_in;
    reg start_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in_domain(clk_in_domain),
        .clk_out_domain(clk_out_domain),
        .start_in(start_in),
        .start_out(start_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in_domain = 0;
        forever #5 clk_in_domain = ~clk_in_domain;
    end

        task reset_dut;

        begin
            start_in = 0;
            pulse_count = 0;
            expected_pulses = 0;

            repeat (10) @(posedge clk_in_domain);
            repeat (10) @(posedge clk_out_domain);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Single Pulse Synchronization", test_num);

            @(posedge clk_in_domain);
            start_in = 1;
            @(posedge clk_in_domain);
            start_in = 0;


            repeat (20) @(posedge clk_out_domain);

            expected_pulses = 1;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Multiple Pulses (Spacing provided)", test_num);


            @(posedge clk_in_domain);
            start_in = 1;
            @(posedge clk_in_domain);
            start_in = 0;


            repeat (15) @(posedge clk_out_domain);


            @(posedge clk_in_domain);
            start_in = 1;
            @(posedge clk_in_domain);
            start_in = 0;

            repeat (20) @(posedge clk_out_domain);

            expected_pulses = 2;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Long input signal", test_num);

            @(posedge clk_in_domain);
            start_in = 1;
            repeat (10) @(posedge clk_in_domain);
            start_in = 0;

            repeat (20) @(posedge clk_out_domain);

            expected_pulses = 1;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Rapid pulse test", test_num);


            repeat (3) begin
                @(posedge clk_in_domain);
                start_in = 1;
                @(posedge clk_in_domain);
                start_in = 0;
                repeat (10) @(posedge clk_in_domain);
            end

            repeat (20) @(posedge clk_out_domain);

            expected_pulses = 3;
            #1;

            check_outputs();
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk_in_domain, clk_out_domain, start_in, start_out);
    end

endmodule
