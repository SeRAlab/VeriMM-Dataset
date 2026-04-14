`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg rst_n;
    reg sel_b1;
    reg sel_b2;
    wire fall;
    wire final_output;
    wire out_always;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .fall(fall),
        .final_output(final_output),
        .out_always(out_always),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            b = 0;
            sel_b1 = 0;
            sel_b2 = 0;
            #15;
            rst_n = 1;
            #5;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 0;
            @(posedge clk);
            a = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 1;
            @(posedge clk);
            a = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            sel_b1 = 1;
            sel_b2 = 1;
            b = 1;
            a = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sel_b1 = 1;
            sel_b2 = 1;
            b = 0;
            a = 0;
            @(posedge clk);
            a = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            sel_b1 = 1;
            sel_b2 = 0;
            a = 1;
            b = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 1;
            @(posedge clk);
            @(posedge clk);
            #1;



            #1;




            check_outputs(0, 1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            sel_b1 = 0;
            sel_b2 = 0;
            a = 0;
            b = 1;
            @(posedge clk);
            b = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
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
        testcase008();
        
        
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
        input expected_fall;
        input expected_final_output;
        input expected_out_always;
        input expected_rise;
        begin
            if (expected_fall === (expected_fall ^ fall ^ expected_fall) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_always === (expected_out_always ^ out_always ^ expected_out_always) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: fall=%b, final_output=%b, out_always=%b, rise=%b",
                         fall, final_output, out_always, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall=%b, final_output=%b, out_always=%b, rise=%b",
                         expected_fall, expected_final_output, expected_out_always, expected_rise);
                $display("  Got:      fall=%b, final_output=%b, out_always=%b, rise=%b",
                         fall, final_output, out_always, rise);
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
        $dumpvars(0,a, b, clk, rst_n, sel_b1, sel_b2, fall, final_output, out_always, rise);
    end

endmodule
