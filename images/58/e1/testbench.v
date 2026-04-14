`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Single Write and Read", test_num);
            reset_dut();


            din = 8'hA5; wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LIFO Sequence (Read 3rd element)", test_num);
            reset_dut();


            din = 8'h11; wr_en = 1; @(posedge clk);
            #1 din = 8'h22; @(posedge clk);
            #1 din = 8'h33; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1; @(posedge clk);
            #1 @(posedge clk);
            #1 @(posedge clk);
            #1 rd_en = 0;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Top of Stack Read", test_num);
            reset_dut();


            din = 8'hAA; wr_en = 1; @(posedge clk);
            #1 din = 8'hBB; @(posedge clk);
            #1 din = 8'hCC; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interleaved Push/Pop", test_num);
            reset_dut();


            din = 8'h10; wr_en = 1; @(posedge clk);
            #1 din = 8'h20; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1; @(posedge clk);
            #1 rd_en = 0;


            din = 8'h30; wr_en = 1; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1; @(posedge clk);
            #1 rd_en = 0;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();


            din = 8'hFF; wr_en = 1; @(posedge clk);
            #1 wr_en = 0;


            rst = 1; @(posedge clk);
            #1 rst = 0; @(posedge clk);


            rd_en = 1; @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(8'h00);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout);
    end

endmodule
