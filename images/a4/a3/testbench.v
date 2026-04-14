`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] delay_q;
    reg resetn;
    reg [7:0] x;
    reg [6:0] y;
    wire [2:0] colourout;
    wire [7:0] xout;
    wire [6:0] yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .delay_q(delay_q),
        .resetn(resetn),
        .x(x),
        .y(y),
        .colourout(colourout),
        .xout(xout),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            delay_q = 0;
            x = 0;
            y = 0;
            repeat(2) @(posedge clk);
            #1 resetn = 1;


        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Low Delay, Counter=1", test_num);
            reset_dut();
            x = 8'd10;
            y = 7'd20;
            delay_q = 20'd500000;

            @(posedge clk);
            #1;



            #1;




            check_outputs(3'd0, 8'd11, 7'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: High Delay, Counter=5", test_num);
            reset_dut();
            x = 8'd30;
            y = 7'd40;
            delay_q = 20'd900000;

            repeat(5) @(posedge clk);
            #1;




            #1;





            check_outputs(3'd1, 8'd31, 7'd41);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Boundary Delay (830,000), Counter=10", test_num);
            reset_dut();
            x = 8'd50;
            y = 7'd10;
            delay_q = 20'd830000;

            repeat(10) @(posedge clk);
            #1;




            #1;





            check_outputs(3'd1, 8'd52, 7'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary Delay (829,999), Counter=15", test_num);
            reset_dut();
            x = 8'd100;
            y = 7'd50;
            delay_q = 20'd829999;

            repeat(15) @(posedge clk);
            #1;




            #1;





            check_outputs(3'd0, 8'd103, 7'd53);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Counter Wrap-around (16 cycles)", test_num);
            reset_dut();
            x = 8'd0;
            y = 7'd0;
            delay_q = 20'd0;

            repeat(16) @(posedge clk);
            #1;




            #1;





            check_outputs(3'd0, 8'd0, 7'd0);
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
        input [2:0] expected_colourout;
        input [7:0] expected_xout;
        input [6:0] expected_yout;
        begin
            if (expected_colourout === (expected_colourout ^ colourout ^ expected_colourout) &&
                expected_xout === (expected_xout ^ xout ^ expected_xout) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: colourout=%h, xout=%h, yout=%h",
                         colourout, xout, yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: colourout=%h, xout=%h, yout=%h",
                         expected_colourout, expected_xout, expected_yout);
                $display("  Got:      colourout=%h, xout=%h, yout=%h",
                         colourout, xout, yout);
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
        $dumpvars(0,clk, delay_q, resetn, x, y, colourout, xout, yout);
    end

endmodule
