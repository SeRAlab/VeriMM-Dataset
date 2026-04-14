`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_i;
    reg quadA_i;
    reg quadB_i;
    reg reset_i;
    wire count_pulse_o;
    wire direction_o;
    wire error_o;
    wire quadA;
    wire quadA_old;
    wire quadB;
    wire quadB_old;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable_i(enable_i),
        .quadA_i(quadA_i),
        .quadB_i(quadB_i),
        .reset_i(reset_i),
        .count_pulse_o(count_pulse_o),
        .direction_o(direction_o),
        .error_o(error_o),
        .quadA(quadA),
        .quadA_old(quadA_old),
        .quadB(quadB),
        .quadB_old(quadB_old)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_i = 1;
            enable_i = 0;
            quadA_i = 0;
            quadB_i = 0;
            @(posedge clk);
            #1;
            reset_i = 0;
            enable_i = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            quadA_i = 1;
            quadB_i = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            quadA_i = 0;
            quadB_i = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            quadA_i = 1; quadB_i = 0;
            @(posedge clk);
            #1;

            quadA_i = 1; quadB_i = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 1, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            quadA_i = 1;
            quadB_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1, 1, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable_i = 0;
            quadA_i = 1;
            quadB_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            quadA_i = 0; quadB_i = 1; @(posedge clk); #1;

            quadA_i = 1; quadB_i = 1; @(posedge clk); #1;

            quadA_i = 1; quadB_i = 0; @(posedge clk); #1;

            quadA_i = 0; quadB_i = 0; @(posedge clk); #1;


            #1;



            check_outputs(1, 0, 0, 0, 1, 0, 0);
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
        testcase007();
        
        
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
        input expected_count_pulse_o;
        input expected_direction_o;
        input expected_error_o;
        input expected_quadA;
        input expected_quadA_old;
        input expected_quadB;
        input expected_quadB_old;
        begin
            if (expected_count_pulse_o === (expected_count_pulse_o ^ count_pulse_o ^ expected_count_pulse_o) &&
                expected_direction_o === (expected_direction_o ^ direction_o ^ expected_direction_o) &&
                expected_error_o === (expected_error_o ^ error_o ^ expected_error_o) &&
                expected_quadA === (expected_quadA ^ quadA ^ expected_quadA) &&
                expected_quadA_old === (expected_quadA_old ^ quadA_old ^ expected_quadA_old) &&
                expected_quadB === (expected_quadB ^ quadB ^ expected_quadB) &&
                expected_quadB_old === (expected_quadB_old ^ quadB_old ^ expected_quadB_old)) begin
                $display("PASS");
                $display("  Outputs: count_pulse_o=%b, direction_o=%b, error_o=%b, quadA=%b, quadA_old=%b, quadB=%b, quadB_old=%b",
                         count_pulse_o, direction_o, error_o, quadA, quadA_old, quadB, quadB_old);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_pulse_o=%b, direction_o=%b, error_o=%b, quadA=%b, quadA_old=%b, quadB=%b, quadB_old=%b",
                         expected_count_pulse_o, expected_direction_o, expected_error_o, expected_quadA, expected_quadA_old, expected_quadB, expected_quadB_old);
                $display("  Got:      count_pulse_o=%b, direction_o=%b, error_o=%b, quadA=%b, quadA_old=%b, quadB=%b, quadB_old=%b",
                         count_pulse_o, direction_o, error_o, quadA, quadA_old, quadB, quadB_old);
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
        $dumpvars(0,clk, enable_i, quadA_i, quadB_i, reset_i, count_pulse_o, direction_o, error_o, quadA, quadA_old, quadB, quadB_old);
    end

endmodule
