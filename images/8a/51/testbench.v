`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg source;
    wire [7:0] power;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .source(source),
        .power(power)
    );

    // Clock generation (10ns period)
    initial begin
        source = 0;
        forever #5 source = ~source;
    end

        task reset_dut;

        begin



            @(negedge source);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Single transition check...");
            reset_dut();


            @(posedge source);


            #2;




            #1;





            check_outputs(8'd2);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Multiple transitions check...");
            reset_dut();


            repeat(3) @(posedge source);

            #2;


            #1;



            check_outputs(8'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Extended source activity...");
            reset_dut();


            repeat(10) @(posedge source);

            #2;

            #1;


            check_outputs(8'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Propagation timing check...");
            reset_dut();

            @(posedge source);

            #1;

            #1;


            check_outputs(8'd2);
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
        input [7:0] expected_power;
        begin
            if (expected_power === (expected_power ^ power ^ expected_power)) begin
                $display("PASS");
                $display("  Outputs: power=%h",
                         power);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: power=%h",
                         expected_power);
                $display("  Got:      power=%h",
                         power);
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
        $dumpvars(0,source, power);
    end

endmodule
