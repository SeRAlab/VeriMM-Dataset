`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] ctrl;
    reg [15:0] din;
    reg [3:0] sel;
    wire [127:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .din(din),
        .sel(sel),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 10'd0;
            din = 16'd0;
            sel = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            din = 16'hAAAA;
            sel = 4'd0;
            ctrl = 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0000000000000000000000000000AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            din = 16'hBBBB;
            sel = 4'd1;
            ctrl = 10'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h000000000000000000000000BBBB0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            din = 16'hFFFF;
            sel = 4'd7;
            ctrl = 10'd0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'hFFFF0000000000000000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            din = 16'h1234;
            sel = 4'd0;
            @(posedge clk);
            #1;


            din = 16'h5678;
            sel = 4'd4;
            @(posedge clk);
            #2;


            #1;



            check_outputs(128'h00000000000056780000000000001234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            din = 16'hC0DE;
            sel = 4'd3;
            ctrl = 10'h3FF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h00000000000000000000C0DE00000000);
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
        input [127:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, ctrl, din, sel, dout);
    end

endmodule
