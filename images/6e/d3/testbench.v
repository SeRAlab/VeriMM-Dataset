`timescale 1ns/1ps

module yet_another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg v;
    wire u;
    wire w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_another_module dut (
        .clock(clock),
        .v(v),
        .u(u),
        .w(w)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            v = 0;

            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            v = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            v = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            v = 1;
            @(posedge clock);
            @(negedge clock);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            v = 1;
            @(posedge clock);

            @(negedge clock);
            v = 1;

            @(posedge clock);
            v = 0;
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clock);
            v = 0;

            @(posedge clock);
            v = 1;
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            v = 1;
            repeat(3) @(posedge clock);
            @(negedge clock);
            #2;

            #1;


            check_outputs(0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("yet_another_module Testbench");
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
        input expected_u;
        input expected_w;
        begin
            if (expected_u === (expected_u ^ u ^ expected_u) &&
                expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: u=%b, w=%b",
                         u, w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b, w=%b",
                         expected_u, expected_w);
                $display("  Got:      u=%b, w=%b",
                         u, w);
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
        $dumpvars(0,clock, v, u, w);
    end

endmodule
