`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pedestrian_button;
    reg reset;
    wire green_light;
    wire red_light;
    wire yellow_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pedestrian_button(pedestrian_button),
        .reset(reset),
        .green_light(green_light),
        .red_light(red_light),
        .yellow_light(yellow_light)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset (Red)", test_num);
            reset_dut();

            #1; #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition Red -> Green", test_num);
            reset_dut();
            @(posedge clk);

            #1; #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition Green -> Yellow", test_num);
            reset_dut();
            repeat(2) @(posedge clk);

            #1; #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full Cycle Yellow -> Red", test_num);
            reset_dut();
            repeat(3) @(posedge clk);

            #1; #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pedestrian button press during Green", test_num);
            reset_dut();

            @(posedge clk);

            pedestrian_button = 1;
            @(posedge clk);
            pedestrian_button = 0;

            #1; #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during Yellow state", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1; #1;
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
        input expected_green_light;
        input expected_red_light;
        input expected_yellow_light;
        begin
            if (expected_green_light === (expected_green_light ^ green_light ^ expected_green_light) &&
                expected_red_light === (expected_red_light ^ red_light ^ expected_red_light) &&
                expected_yellow_light === (expected_yellow_light ^ yellow_light ^ expected_yellow_light)) begin
                $display("PASS");
                $display("  Outputs: green_light=%b, red_light=%b, yellow_light=%b",
                         green_light, red_light, yellow_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_light=%b, red_light=%b, yellow_light=%b",
                         expected_green_light, expected_red_light, expected_yellow_light);
                $display("  Got:      green_light=%b, red_light=%b, yellow_light=%b",
                         green_light, red_light, yellow_light);
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
        $dumpvars(0,clk, pedestrian_button, reset, green_light, red_light, yellow_light);
    end

endmodule
