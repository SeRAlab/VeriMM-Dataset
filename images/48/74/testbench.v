`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg i_master_ready;
    reg i_oh_en;
    reg [31:0] i_out_address;
    reg [31:0] i_out_data;
    reg [27:0] i_out_data_count;
    reg [31:0] i_out_status;
    reg [31:0] i_sim_in_address;
    reg [31:0] i_sim_in_command;
    reg [31:0] i_sim_in_data;
    reg [31:0] i_sim_in_data_count;
    reg i_sim_in_ready;
    reg i_sim_in_reset;
    reg i_sim_out_ready;
    reg rst;
    wire o_ih_ready;
    wire o_ih_reset;
    wire [31:0] o_in_address;
    wire [31:0] o_in_command;
    wire [31:0] o_in_data;
    wire [27:0] o_in_data_count;
    wire o_oh_ready;
    wire o_sim_master_ready;
    wire [31:0] o_sim_out_address;
    wire [31:0] o_sim_out_data;
    wire [27:0] o_sim_out_data_count;
    wire o_sim_out_en;
    wire [31:0] o_sim_out_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_master_ready(i_master_ready),
        .i_oh_en(i_oh_en),
        .i_out_address(i_out_address),
        .i_out_data(i_out_data),
        .i_out_data_count(i_out_data_count),
        .i_out_status(i_out_status),
        .i_sim_in_address(i_sim_in_address),
        .i_sim_in_command(i_sim_in_command),
        .i_sim_in_data(i_sim_in_data),
        .i_sim_in_data_count(i_sim_in_data_count),
        .i_sim_in_ready(i_sim_in_ready),
        .i_sim_in_reset(i_sim_in_reset),
        .i_sim_out_ready(i_sim_out_ready),
        .rst(rst),
        .o_ih_ready(o_ih_ready),
        .o_ih_reset(o_ih_reset),
        .o_in_address(o_in_address),
        .o_in_command(o_in_command),
        .o_in_data(o_in_data),
        .o_in_data_count(o_in_data_count),
        .o_oh_ready(o_oh_ready),
        .o_sim_master_ready(o_sim_master_ready),
        .o_sim_out_address(o_sim_out_address),
        .o_sim_out_data(o_sim_out_data),
        .o_sim_out_data_count(o_sim_out_data_count),
        .o_sim_out_en(o_sim_out_en),
        .o_sim_out_status(o_sim_out_status)
    );
    task init_signals;

        begin
            i_master_ready = 0;
            i_oh_en = 0;
            i_out_address = 0;
            i_out_data = 0;
            i_out_data_count = 0;
            i_out_status = 0;
            i_sim_in_address = 0;
            i_sim_in_command = 0;
            i_sim_in_data = 0;
            i_sim_in_data_count = 0;
            i_sim_in_ready = 0;
            i_sim_in_reset = 0;
            i_sim_out_ready = 0;
            rst = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: System Reset Behavior", test_num);
            init_signals();
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Simulation Input to Master Command Interface", test_num);
            init_signals();
            rst = 0;
            @(posedge clk);


            i_sim_in_reset = 1'b0;
            i_sim_in_ready = 1'b1;
            i_sim_in_command = 32'hA5A5_B6B6;
            i_sim_in_address = 32'h1234_5678;
            i_sim_in_data = 32'hDEAD_BEEF;
            i_sim_in_data_count = 32'h0000_00FF;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 32'h1234_5678, 32'hA5A5_B6B6, 32'hDEAD_BEEF, 28'h000_00FF,
                          0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Master Response to Simulation Output Interface", test_num);
            init_signals();
            rst = 0;
            @(posedge clk);


            i_oh_en = 1'b1;
            i_out_status = 32'h0000_0001;
            i_out_address = 32'h8765_4321;
            i_out_data = 32'hCAFE_BABE;
            i_out_data_count = 28'h0ABC_DEF;
            i_sim_out_ready = 1'b1;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(0, 0, 0, 0, 0, 0,
                          1'b1, 0, 32'h8765_4321, 32'hCAFE_BABE, 28'h0ABC_DEF, 1'b1, 32'h0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Master Readiness Status Propagation", test_num);
            init_signals();
            rst = 0;
            @(posedge clk);

            i_master_ready = 1'b1;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 1'b1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Concurrent Bi-directional Data and Truncation", test_num);
            init_signals();
            rst = 0;
            @(posedge clk);


            i_sim_in_ready = 1'b1;
            i_sim_in_command = 32'h1111_2222;
            i_sim_in_data_count = 32'hF000_0005;


            i_master_ready = 1'b1;
            i_oh_en = 1'b1;
            i_out_status = 32'h8000_0000;
            i_out_data_count = 28'h7FF_FFFF;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 0, 0, 32'h1111_2222, 0, 28'h000_0005,
                          0, 1'b1, 0, 0, 28'h7FF_FFFF, 1'b1, 32'h8000_0000);
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
        input expected_o_ih_ready;
        input expected_o_ih_reset;
        input [31:0] expected_o_in_address;
        input [31:0] expected_o_in_command;
        input [31:0] expected_o_in_data;
        input [27:0] expected_o_in_data_count;
        input expected_o_oh_ready;
        input expected_o_sim_master_ready;
        input [31:0] expected_o_sim_out_address;
        input [31:0] expected_o_sim_out_data;
        input [27:0] expected_o_sim_out_data_count;
        input expected_o_sim_out_en;
        input [31:0] expected_o_sim_out_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_ih_ready === (expected_o_ih_ready ^ o_ih_ready ^ expected_o_ih_ready) &&
                expected_o_ih_reset === (expected_o_ih_reset ^ o_ih_reset ^ expected_o_ih_reset) &&
                expected_o_in_address === (expected_o_in_address ^ o_in_address ^ expected_o_in_address) &&
                expected_o_in_command === (expected_o_in_command ^ o_in_command ^ expected_o_in_command) &&
                expected_o_in_data === (expected_o_in_data ^ o_in_data ^ expected_o_in_data) &&
                expected_o_in_data_count === (expected_o_in_data_count ^ o_in_data_count ^ expected_o_in_data_count) &&
                expected_o_oh_ready === (expected_o_oh_ready ^ o_oh_ready ^ expected_o_oh_ready) &&
                expected_o_sim_master_ready === (expected_o_sim_master_ready ^ o_sim_master_ready ^ expected_o_sim_master_ready) &&
                expected_o_sim_out_address === (expected_o_sim_out_address ^ o_sim_out_address ^ expected_o_sim_out_address) &&
                expected_o_sim_out_data === (expected_o_sim_out_data ^ o_sim_out_data ^ expected_o_sim_out_data) &&
                expected_o_sim_out_data_count === (expected_o_sim_out_data_count ^ o_sim_out_data_count ^ expected_o_sim_out_data_count) &&
                expected_o_sim_out_en === (expected_o_sim_out_en ^ o_sim_out_en ^ expected_o_sim_out_en) &&
                expected_o_sim_out_status === (expected_o_sim_out_status ^ o_sim_out_status ^ expected_o_sim_out_status)) begin
                $display("PASS");
                $display("  Outputs: o_ih_ready=%b, o_ih_reset=%b, o_in_address=%h, o_in_command=%h, o_in_data=%h, o_in_data_count=%h, o_oh_ready=%b, o_sim_master_ready=%b, o_sim_out_address=%h, o_sim_out_data=%h, o_sim_out_data_count=%h, o_sim_out_en=%b, o_sim_out_status=%h",
                         o_ih_ready, o_ih_reset, o_in_address, o_in_command, o_in_data, o_in_data_count, o_oh_ready, o_sim_master_ready, o_sim_out_address, o_sim_out_data, o_sim_out_data_count, o_sim_out_en, o_sim_out_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_ih_ready=%b, o_ih_reset=%b, o_in_address=%h, o_in_command=%h, o_in_data=%h, o_in_data_count=%h, o_oh_ready=%b, o_sim_master_ready=%b, o_sim_out_address=%h, o_sim_out_data=%h, o_sim_out_data_count=%h, o_sim_out_en=%b, o_sim_out_status=%h",
                         expected_o_ih_ready, expected_o_ih_reset, expected_o_in_address, expected_o_in_command, expected_o_in_data, expected_o_in_data_count, expected_o_oh_ready, expected_o_sim_master_ready, expected_o_sim_out_address, expected_o_sim_out_data, expected_o_sim_out_data_count, expected_o_sim_out_en, expected_o_sim_out_status);
                $display("  Got:      o_ih_ready=%b, o_ih_reset=%b, o_in_address=%h, o_in_command=%h, o_in_data=%h, o_in_data_count=%h, o_oh_ready=%b, o_sim_master_ready=%b, o_sim_out_address=%h, o_sim_out_data=%h, o_sim_out_data_count=%h, o_sim_out_en=%b, o_sim_out_status=%h",
                         o_ih_ready, o_ih_reset, o_in_address, o_in_command, o_in_data, o_in_data_count, o_oh_ready, o_sim_master_ready, o_sim_out_address, o_sim_out_data, o_sim_out_data_count, o_sim_out_en, o_sim_out_status);
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

endmodule
