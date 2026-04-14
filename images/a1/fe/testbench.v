`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [18:0] datain;
    reg dst_rdy_i;
    reg reset;
    reg src_rdy_i;
    wire [18:0] dataout;
    wire dst_rdy_o;
    wire src_rdy_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .datain(datain),
        .dst_rdy_i(dst_rdy_i),
        .reset(reset),
        .src_rdy_i(src_rdy_i),
        .dataout(dataout),
        .dst_rdy_o(dst_rdy_o),
        .src_rdy_o(src_rdy_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            datain = 0;
            src_rdy_i = 0;
            dst_rdy_i = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();
            dst_rdy_i = 1;
            #1;

            #1;


            check_outputs(19'h00000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Dummy Data in Dummy State", test_num);
            reset_dut();
            dst_rdy_i = 1;
            src_rdy_i = 1;
            datain = 19'h2AAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(19'h2AAAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transition to Packet State", test_num);
            reset_dut();
            dst_rdy_i = 1;
            src_rdy_i = 1;
            datain = 19'h15555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(19'h15555, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Destination Backpressure", test_num);
            reset_dut();
            dst_rdy_i = 0;
            src_rdy_i = 1;
            datain = 19'h12345;
            @(posedge clk);
            #1;

            #1;


            check_outputs(19'h12345, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Clear Signal Operation", test_num);
            reset_dut();

            dst_rdy_i = 1;
            src_rdy_i = 1;
            datain = 19'h0FFFF;
            @(posedge clk);
            #1;

            clear = 1;
            @(posedge clk);
            #1;
            clear = 0;
            src_rdy_i = 1;
            datain = 19'h0FFFF;
            #1;

            #1;


            check_outputs(19'h0FFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Continuous Packet Flow", test_num);
            reset_dut();
            dst_rdy_i = 1;
            src_rdy_i = 1;
            datain = 19'h00001;
            @(posedge clk);
            #1;
            datain = 19'h00002;
            @(posedge clk);
            #1;
            datain = 19'h00003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(19'h00003, 1'b1, 1'b1);
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
        input [18:0] expected_dataout;
        input expected_dst_rdy_o;
        input expected_src_rdy_o;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_dst_rdy_o === (expected_dst_rdy_o ^ dst_rdy_o ^ expected_dst_rdy_o) &&
                expected_src_rdy_o === (expected_src_rdy_o ^ src_rdy_o ^ expected_src_rdy_o)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         dataout, dst_rdy_o, src_rdy_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         expected_dataout, expected_dst_rdy_o, expected_src_rdy_o);
                $display("  Got:      dataout=%h, dst_rdy_o=%b, src_rdy_o=%b",
                         dataout, dst_rdy_o, src_rdy_o);
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
        $dumpvars(0,clear, clk, datain, dst_rdy_i, reset, src_rdy_i, dataout, dst_rdy_o, src_rdy_o);
    end

endmodule
