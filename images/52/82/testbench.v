`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pedestrian_button;
    reg reset;
    wire green;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pedestrian_button(pedestrian_button),
        .reset(reset),
        .green(green),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pedestrian_button = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Transition Cycle...");
            test_num = 2;
            reset_dut();



            repeat (200) @(posedge clk);

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Pedestrian Button in Green State...");
            test_num = 3;
            reset_dut();


            wait(green == 1);
            repeat (2) @(posedge clk);


            pedestrian_button = 1;
            @(posedge clk);
            pedestrian_button = 0;


            repeat (50) @(posedge clk);

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mid-Cycle Reset...");
            test_num = 4;
            reset_dut();


            wait(green == 1);
            repeat (5) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Yellow Light to Red Transition...");
            test_num = 5;
            reset_dut();


            wait(yellow == 1);


            wait(red == 1);
            repeat (2) @(posedge clk);

            #1;


            check_outputs(0, 1, 0);
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
        input expected_green;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, red=%b, yellow=%b",
                         green, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, red=%b, yellow=%b",
                         expected_green, expected_red, expected_yellow);
                $display("  Got:      green=%b, red=%b, yellow=%b",
                         green, red, yellow);
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
        $dumpvars(0,clk, pedestrian_button, reset, green, red, yellow);
    end

endmodule
