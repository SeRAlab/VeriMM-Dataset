`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [24:0] data_1;
    reg [24:0] data_2;
    reg [24:0] data_3;
    reg [24:0] data_4;
    reg [15:0] ddata_in;
    wire [7:0] data_p;
    wire [15:0] ddata_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_1(data_1),
        .data_2(data_2),
        .data_3(data_3),
        .data_4(data_4),
        .ddata_in(ddata_in),
        .data_p(data_p),
        .ddata_out(ddata_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_1 = 0;
            data_2 = 0;
            data_3 = 0;
            data_4 = 0;
            ddata_in = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple sum (10+20+30+40=100)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = 25'sd10;
            data_2 = 25'sd20;
            data_3 = 25'sd30;
            data_4 = 25'sd40;
            ddata_in = 16'hAAAA;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper clamp (200+200+200+200=800 -> 255)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = 25'sd200;
            data_2 = 25'sd200;
            data_3 = 25'sd200;
            data_4 = 25'sd200;
            ddata_in = 16'hBBBB;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower clamp (-100-50+20+10=-120 -> 0)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = -25'sd100;
            data_2 = -25'sd50;
            data_3 = 25'sd20;
            data_4 = 25'sd10;
            ddata_in = 16'hCCCC;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary zero (50-50+20-20=0)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = 25'sd50;
            data_2 = -25'sd50;
            data_3 = 25'sd20;
            data_4 = -25'sd20;
            ddata_in = 16'h1234;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary 255 (100+100+50+5=255)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = 25'sd100;
            data_2 = 25'sd100;
            data_3 = 25'sd50;
            data_4 = 25'sd5;
            ddata_in = 16'hFFFF;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large positive values (Saturation check)", test_num);
            reset_dut();
            @(posedge clk);
            data_1 = 25'h0FFFFFF;
            data_2 = 25'h0FFFFFF;
            data_3 = 25'h0FFFFFF;
            data_4 = 25'h0FFFFFF;
            ddata_in = 16'h55AA;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 16'h55AA);
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
        input [7:0] expected_data_p;
        input [15:0] expected_ddata_out;
        begin
            if (expected_data_p === (expected_data_p ^ data_p ^ expected_data_p) &&
                expected_ddata_out === (expected_ddata_out ^ ddata_out ^ expected_ddata_out)) begin
                $display("PASS");
                $display("  Outputs: data_p=%h, ddata_out=%h",
                         data_p, ddata_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_p=%h, ddata_out=%h",
                         expected_data_p, expected_ddata_out);
                $display("  Got:      data_p=%h, ddata_out=%h",
                         data_p, ddata_out);
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
        $dumpvars(0,clk, data_1, data_2, data_3, data_4, ddata_in, data_p, ddata_out);
    end

endmodule
