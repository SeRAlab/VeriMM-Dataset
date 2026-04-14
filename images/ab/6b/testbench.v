`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg avs_ctrl_address;
    reg avs_ctrl_write;
    reg [31:0] avs_ctrl_writedata;
    reg clk;
    reg reset;
    reg sync;
    reg [3:0] trigger;
    wire [15:0] data;
    wire enable;
    wire write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_ctrl_address(avs_ctrl_address),
        .avs_ctrl_write(avs_ctrl_write),
        .avs_ctrl_writedata(avs_ctrl_writedata),
        .clk(clk),
        .reset(reset),
        .sync(sync),
        .trigger(trigger),
        .data(data),
        .enable(enable),
        .write(write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            avs_ctrl_address = 0;
            avs_ctrl_write = 0;
            avs_ctrl_writedata = 0;
            sync = 0;
            trigger = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            avs_ctrl_address = 1'b0;
            avs_ctrl_writedata = 32'h1;
            avs_ctrl_write = 1'b1;
            @(posedge clk);
            #1;
            avs_ctrl_write = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            trigger = 4'b0010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            avs_ctrl_address = 1'b0;
            avs_ctrl_writedata = 32'h1;
            avs_ctrl_write = 1'b1;
            @(posedge clk); #1;
            avs_ctrl_write = 1'b0;


            trigger = 4'hA;
            sync = 1'b1;
            @(posedge clk); #1;
            sync = 1'b0;
            @(posedge clk); #1;



            #1;




            check_outputs(16'hA001, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            avs_ctrl_address = 1'b1;
            avs_ctrl_writedata = 32'hABC;
            avs_ctrl_write = 1'b1;
            @(posedge clk); #1;
            avs_ctrl_write = 1'b0;

            trigger = 4'h5;
            @(posedge clk); #1;



            #1;




            check_outputs(16'h5ABC, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            trigger = 4'hF;
            sync = 1'b1;
            @(posedge clk); #1;
            sync = 1'b0;
            @(posedge clk); #1;


            #1;



            check_outputs(16'hF000, 1'b0, 1'b1);
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
        input [15:0] expected_data;
        input expected_enable;
        input expected_write;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_write === (expected_write ^ write ^ expected_write)) begin
                $display("PASS");
                $display("  Outputs: data=%h, enable=%b, write=%b",
                         data, enable, write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, enable=%b, write=%b",
                         expected_data, expected_enable, expected_write);
                $display("  Got:      data=%h, enable=%b, write=%b",
                         data, enable, write);
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
        $dumpvars(0,avs_ctrl_address, avs_ctrl_write, avs_ctrl_writedata, clk, reset, sync, trigger, data, enable, write);
    end

endmodule
