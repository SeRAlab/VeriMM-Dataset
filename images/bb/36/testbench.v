`timescale 1ns/1ps

module my_module_tb;

    // Testbench signals (sequential circuit)
    reg b;
    reg clock;
    wire a;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_module dut (
        .b(b),
        .clock(clock),
        .a(a),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            b = 0;

            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;



            @(posedge clock);


            @(negedge clock) b = 1;


            @(posedge clock);


            @(negedge clock) b = 1;



            @(posedge clock);
            #1; b = 0;


            @(negedge clock) b = 0;



            @(posedge clock);
            #1; b = 1;


            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            @(posedge clock);

            @(negedge clock);
            #2;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            b = 1;

            @(posedge clock);
            #2;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            @(posedge clock);

            @(negedge clock) b = 1;

            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            @(negedge clock) b = 1;
            @(posedge clock);

            @(negedge clock) b = 0;
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
        $display("my_module Testbench");
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
        input expected_a;
        input expected_c;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: a=%b, c=%b",
                         a, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, c=%b",
                         expected_a, expected_c);
                $display("  Got:      a=%b, c=%b",
                         a, c);
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
        $dumpvars(0,b, clock, a, c);
    end

endmodule
