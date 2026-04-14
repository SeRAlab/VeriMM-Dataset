`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [31:0] i_daddress;
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
            i_daddress = 32'h0;
            i_mem_load_rd = 11'h0;
            i_mem_read_data = 32'h0;
            i_mem_read_data_valid = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            i_mem_stall = 0;
            i_mem_read_data = 32'hDEADBEEF;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h0A5;
            i_daddress = 32'h1000;

            @(posedge i_clk);
            #2;

            $display("Testcase %0d: Basic Pass-through", test_num);
            #1;

            check_outputs(11'h0A5, 32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            i_mem_stall = 0;
            i_mem_read_data = 32'h12345678;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h7FF;
            @(posedge i_clk);
            #1;


            i_mem_stall = 1;
            i_mem_read_data = 32'h87654321;
            i_mem_read_data_valid = 0;
            i_mem_load_rd = 11'h000;

            @(posedge i_clk);
            #2;

            $display("Testcase %0d: Stall Holding Previous Value", test_num);

            #1;


            check_outputs(11'h7FF, 32'h12345678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            i_mem_stall = 1;
            i_mem_read_data = 32'hAAAA_BBBB;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h123;
            @(posedge i_clk);
            #1;


            i_mem_stall = 0;
            @(posedge i_clk);
            #2;

            $display("Testcase %0d: Stall Release", test_num);

            #1;


            check_outputs(11'h123, 32'hAAAA_BBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            i_mem_stall = 0;
            i_mem_read_data = 32'h5555_AAAA;
            i_mem_read_data_valid = 0;
            i_mem_load_rd = 11'h3FF;

            @(posedge i_clk);
            #2;

            $display("Testcase %0d: Valid Bit Propagation (Low)", test_num);
            #1;

            check_outputs(11'h3FF, 32'h5555_AAAA, 1'b0);
        end
        endtask

    task testcase005;

        reg [31:0] last_data;
        reg [10:0] last_rd;
        begin
            test_num = 5;
            reset_dut();

            i_mem_stall = 0;


            i_mem_read_data = 32'hC0FFEE;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h01;
            @(posedge i_clk);
            #1;


            i_mem_read_data = 32'hBABE;
            i_mem_read_data_valid = 1;
            i_mem_load_rd = 11'h02;
            @(posedge i_clk);
            #2;

            $display("Testcase %0d: Multi-cycle Stream", test_num);
            #1;

            check_outputs(11'h02, 32'hBABE, 1'b1);
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
        $dumpvars(0,i_clk, i_daddress, i_mem_load_rd, i_mem_read_data, i_mem_read_data_valid, i_mem_stall, o_wb_load_rd, o_wb_read_data, o_wb_read_data_valid);
    end

endmodule
