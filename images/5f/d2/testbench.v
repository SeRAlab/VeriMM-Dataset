`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_daddress;
    reg i_daddress_valid;
    reg [10:0] i_mem_load_rd;
    reg [31:0] i_mem_read_data;
    reg i_mem_read_data_valid;
    reg i_mem_stall;
    wire [10:0] o_wb_load_rd;
    wire [31:0] o_wb_read_data;
    wire o_wb_read_data_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_daddress(i_daddress),
        .i_daddress_valid(i_daddress_valid),
        .i_mem_load_rd(i_mem_load_rd),
        .i_mem_read_data(i_mem_read_data),
        .i_mem_read_data_valid(i_mem_read_data_valid),
        .i_mem_stall(i_mem_stall),
        .o_wb_load_rd(o_wb_load_rd),
        .o_wb_read_data(o_wb_read_data),
        .o_wb_read_data_valid(o_wb_read_data_valid)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_mem_stall = 0;
            i_mem_read_data = 32'h0;
            i_mem_read_data_valid = 0;
            i_mem_load_rd = 11'h0;
            i_daddress = 32'h0;
            i_daddress_valid = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Basic Load Operation", test_num);

            i_mem_stall = 0;
            i_mem_read_data = 32'hDEADBEEF;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h055;

            @(posedge i_clk);
            #1;
            #1;

            check_outputs(11'h055, 32'hDEADBEEF, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Stall Operation", test_num);


            i_mem_stall = 0;
            i_mem_read_data = 32'hAAAA_BBBB;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h010;
            @(posedge i_clk);
            #1;


            i_mem_stall = 1;
            i_mem_read_data = 32'h1234_5678;
            i_mem_read_data_valid = 0;
            i_mem_load_rd = 11'h020;
            @(posedge i_clk);
            #1;


            #1;



            check_outputs(11'h010, 32'hAAAA_BBBB, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Data Validity Flag", test_num);

            i_mem_stall = 0;
            i_mem_read_data = 32'hCAFE_BABE;
            i_mem_read_data_valid = 0;
            i_mem_load_rd = 11'h00A;

            @(posedge i_clk);
            #1;
            #1;

            check_outputs(11'h00A, 32'hCAFE_BABE, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Recovery from Stall", test_num);


            i_mem_stall = 1;
            i_mem_read_data = 32'h1111_2222;
            i_mem_load_rd = 11'h001;
            @(posedge i_clk);
            #1;


            i_mem_stall = 0;
            i_mem_read_data = 32'h8888_9999;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h002;
            @(posedge i_clk);
            #1;

            #1;


            check_outputs(11'h002, 32'h8888_9999, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Sequential Stream", test_num);

            i_mem_read_data = 32'h0000_0001; i_mem_load_rd = 11'h1; i_mem_read_data_valid = 1;
            @(posedge i_clk);
            #1;
            i_mem_read_data = 32'h0000_0002; i_mem_load_rd = 11'h2; i_mem_read_data_valid = 1;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(11'h2, 32'h0000_0002, 1);
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
        input [10:0] expected_o_wb_load_rd;
        input [31:0] expected_o_wb_read_data;
        input expected_o_wb_read_data_valid;
        begin
            if (expected_o_wb_load_rd === (expected_o_wb_load_rd ^ o_wb_load_rd ^ expected_o_wb_load_rd) &&
                expected_o_wb_read_data === (expected_o_wb_read_data ^ o_wb_read_data ^ expected_o_wb_read_data) &&
                expected_o_wb_read_data_valid === (expected_o_wb_read_data_valid ^ o_wb_read_data_valid ^ expected_o_wb_read_data_valid)) begin
                $display("PASS");
                $display("  Outputs: o_wb_load_rd=%h, o_wb_read_data=%h, o_wb_read_data_valid=%b",
                         o_wb_load_rd, o_wb_read_data, o_wb_read_data_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wb_load_rd=%h, o_wb_read_data=%h, o_wb_read_data_valid=%b",
                         expected_o_wb_load_rd, expected_o_wb_read_data, expected_o_wb_read_data_valid);
                $display("  Got:      o_wb_load_rd=%h, o_wb_read_data=%h, o_wb_read_data_valid=%b",
                         o_wb_load_rd, o_wb_read_data, o_wb_read_data_valid);
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
        $dumpvars(0,i_clk, i_daddress, i_daddress_valid, i_mem_load_rd, i_mem_read_data, i_mem_read_data_valid, i_mem_stall, o_wb_load_rd, o_wb_read_data, o_wb_read_data_valid);
    end

endmodule
