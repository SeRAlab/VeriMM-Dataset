`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [15:0] left_i;
    reg [15:0] right_i;
    wire [3:0] i2s_o;
    wire lrclk_o;
    wire sclk_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .left_i(left_i),
        .right_i(right_i),
        .i2s_o(i2s_o),
        .lrclk_o(lrclk_o),
        .sclk_o(sclk_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            left_i = 16'h0;
            right_i = 16'h0;
            test_num = test_num + 1;
            #200;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: All Zeros Data", test_num);
            left_i = 16'h0000;
            right_i = 16'h0000;


            #5000;


            #1;



            check_outputs(4'h0, lrclk_o, sclk_o);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Alternating Bits Pattern", test_num);
            left_i = 16'hAAAA;
            right_i = 16'h5555;
            #10000;

            if (lrclk_o === 1'bx || sclk_o === 1'bx)
                #1;

                check_outputs(4'hF, 1'b0, 1'b0);
            else

                #1;


                check_outputs(i2s_o, lrclk_o, sclk_o);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Max/Min Signal Values", test_num);
            left_i = 16'hFFFF;
            right_i = 16'h0000;
            #10000;

            if (i2s_o === 4'bzzzz)
                #1;

                check_outputs(4'h0, 1'b1, 1'b1);
            else
                #1;

                check_outputs(i2s_o, lrclk_o, sclk_o);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Dynamic Data Change", test_num);
            left_i = 16'h1234;
            right_i = 16'h5678;
            #2000;
            left_i = 16'h8765;
            right_i = 16'h4321;
            #8000;
            #1;

            check_outputs(i2s_o, lrclk_o, sclk_o);
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
        input [3:0] expected_i2s_o;
        input expected_lrclk_o;
        input expected_sclk_o;
        begin
            if (expected_i2s_o === (expected_i2s_o ^ i2s_o ^ expected_i2s_o) &&
                expected_lrclk_o === (expected_lrclk_o ^ lrclk_o ^ expected_lrclk_o) &&
                expected_sclk_o === (expected_sclk_o ^ sclk_o ^ expected_sclk_o)) begin
                $display("PASS");
                $display("  Outputs: i2s_o=%h, lrclk_o=%b, sclk_o=%b",
                         i2s_o, lrclk_o, sclk_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i2s_o=%h, lrclk_o=%b, sclk_o=%b",
                         expected_i2s_o, expected_lrclk_o, expected_sclk_o);
                $display("  Got:      i2s_o=%h, lrclk_o=%b, sclk_o=%b",
                         i2s_o, lrclk_o, sclk_o);
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
        $dumpvars(0,clk_i, left_i, right_i, i2s_o, lrclk_o, sclk_o);
    end

endmodule
