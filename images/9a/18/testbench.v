`timescale 1ns/1ps

module some_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg t;
    wire r;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    some_module dut (
        .clock(clock),
        .t(t),
        .r(r),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin


            t = 0;
            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: clk=1, t=0", test_num);
            t = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: clk=1, t=1", test_num);
            t = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: clk=0, t=1", test_num);
            t = 1;
            @(negedge clock);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: clk=0, t=0", test_num);
            t = 0;
            @(negedge clock);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Change t (0->1) while clk is High", test_num);
            t = 0;
            @(posedge clock);
            #2;
            t = 1;
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Change t (1->0) while clk is Low", test_num);
            t = 1;
            @(negedge clock);
            #2;
            t = 0;
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("some_module Testbench");
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
        input expected_r;
        input expected_s;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: r=%b, s=%b",
                         r, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b, s=%b",
                         expected_r, expected_s);
                $display("  Got:      r=%b, s=%b",
                         r, s);
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
        $dumpvars(0,clock, t, r, s);
    end

endmodule
