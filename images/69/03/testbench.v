`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg rst_n;
    reg sel_b1;
    wire down;
    wire final_out;
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
        .down(down),
        .final_out(final_out),
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
            a = 0;
            b = 0;
            sel_b1 = 0;
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simultaneous Rising Edge Detection (a: 0->1, b: 0->1)", test_num);
            reset_dut();


            a = 0; b = 0; sel_b1 = 0;
            @(posedge clk); #1;


            a = 1; b = 1;
            @(posedge clk); #1;



            #1;




            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Simultaneous Falling Edge Detection (a: 1->0, b: 1->0)", test_num);
            reset_dut();


            a = 1; b = 1; sel_b1 = 1;
            @(posedge clk); #1;


            a = 0; b = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Multiplexer Selection (sel_b1)", test_num);
            reset_dut();


            a = 1; b = 0; sel_b1 = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 0, 0, 0);


            sel_b1 = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Non-simultaneous Rising Edge (Only 'a' rises)", test_num);
            reset_dut();

            a = 0; b = 0;
            @(posedge clk); #1;

            a = 1; b = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Testing Signal Stability", test_num);
            reset_dut();

            a = 1; b = 1; sel_b1 = 0;
            @(posedge clk); #1;


            @(posedge clk); #1;

            #1;


            check_outputs(0, 0, 1, 0);
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
        input expected_down;
        input expected_final_out;
        input expected_out_always;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out_always === (expected_out_always ^ out_always ^ expected_out_always) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, final_out=%b, out_always=%b, rise=%b",
                         down, final_out, out_always, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, final_out=%b, out_always=%b, rise=%b",
                         expected_down, expected_final_out, expected_out_always, expected_rise);
                $display("  Got:      down=%b, final_out=%b, out_always=%b, rise=%b",
                         down, final_out, out_always, rise);
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
        $dumpvars(0,a, b, clk, rst_n, sel_b1, down, final_out, out_always, rise);
    end

endmodule
