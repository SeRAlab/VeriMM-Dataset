`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] height;
    reg [7:0] i_alpha;
    reg [11:0] left;
    reg rst_n;
    reg [11:0] top;
    reg [11:0] width;
    reg [11:0] x;
    reg [11:0] y;
    wire [7:0] o_alpha;
    wire rdreq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .height(height),
        .i_alpha(i_alpha),
        .left(left),
        .rst_n(rst_n),
        .top(top),
        .width(width),
        .x(x),
        .y(y),
        .o_alpha(o_alpha),
        .rdreq(rdreq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_alpha = 0;
            top = 0;
            left = 0;
            width = 0;
            height = 0;
            x = 0;
            y = 0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            left = 12'd100; top = 12'd100;
            width = 12'd50; height = 12'd50;
            x = 12'd125; y = 12'd125;
            i_alpha = 8'hAA;


            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            left = 12'd100; top = 12'd100;
            width = 12'd50; height = 12'd50;
            x = 12'd50; y = 12'd125;
            i_alpha = 8'hBB;

            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            left = 12'd100; top = 12'd100;
            width = 12'd50; height = 12'd50;
            x = 12'd100; y = 12'd100;
            i_alpha = 8'hCC;

            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            left = 12'd100; top = 12'd100;
            width = 12'd50; height = 12'd50;
            x = 12'd149; y = 12'd149;
            i_alpha = 8'hDD;

            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hDD, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            left = 12'd100; top = 12'd100;
            width = 12'd50; height = 12'd50;
            x = 12'd150; y = 12'd125;
            i_alpha = 8'hEE;

            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            left = 10; top = 10; width = 100; height = 100;
            x = 50; y = 50; i_alpha = 8'hFF;

            #1;
            @(posedge clk);

            rst_n = 0;
            #1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            left = 10; top = 10; width = 10; height = 10;
            i_alpha = 8'h55;


            x = 15; y = 15;
            @(posedge clk);


            x = 0; y = 0;
            #1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_o_alpha;
        input expected_rdreq;
        begin
            if (expected_o_alpha === (expected_o_alpha ^ o_alpha ^ expected_o_alpha) &&
                expected_rdreq === (expected_rdreq ^ rdreq ^ expected_rdreq)) begin
                $display("PASS");
                $display("  Outputs: o_alpha=%h, rdreq=%b",
                         o_alpha, rdreq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_alpha=%h, rdreq=%b",
                         expected_o_alpha, expected_rdreq);
                $display("  Got:      o_alpha=%h, rdreq=%b",
                         o_alpha, rdreq);
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
        $dumpvars(0,clk, height, i_alpha, left, rst_n, top, width, x, y, o_alpha, rdreq);
    end

endmodule
