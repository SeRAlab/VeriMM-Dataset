`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] c_data_i;
    reg clk;
    reg [31:0] mem_c_addr_i;
    reg mem_c_read_en;
    reg [31:0] mem_r_addr_i;
    reg mem_r_read_en;
    reg [31:0] r_data_i;
    reg rst;
    reg [31:0] wb_addr_i;
    reg wb_c_we_i;
    reg [31:0] wb_data_i;
    reg wb_r_we_i;
    wire [31:0] c_addr_o;
    wire [31:0] c_data_o;
    wire c_we_o;
    wire [31:0] mem_c_data_o;
    wire [31:0] mem_r_data_o;
    wire [31:0] r_addr_o;
    wire [31:0] r_data_o;
    wire r_rw_conflict_o;
    wire r_we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_data_i(c_data_i),
        .clk(clk),
        .mem_c_addr_i(mem_c_addr_i),
        .mem_c_read_en(mem_c_read_en),
        .mem_r_addr_i(mem_r_addr_i),
        .mem_r_read_en(mem_r_read_en),
        .r_data_i(r_data_i),
        .rst(rst),
        .wb_addr_i(wb_addr_i),
        .wb_c_we_i(wb_c_we_i),
        .wb_data_i(wb_data_i),
        .wb_r_we_i(wb_r_we_i),
        .c_addr_o(c_addr_o),
        .c_data_o(c_data_o),
        .c_we_o(c_we_o),
        .mem_c_data_o(mem_c_data_o),
        .mem_r_data_o(mem_r_data_o),
        .r_addr_o(r_addr_o),
        .r_data_o(r_data_o),
        .r_rw_conflict_o(r_rw_conflict_o),
        .r_we_o(r_we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            c_data_i = 0;
            mem_c_addr_i = 0;
            mem_c_read_en = 0;
            mem_r_addr_i = 0;
            mem_r_read_en = 0;
            r_data_i = 0;
            wb_addr_i = 0;
            wb_c_we_i = 0;
            wb_data_i = 0;
            wb_r_we_i = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            wb_data_i = 32'hDEADBEEF;
            wb_addr_i = 32'h00001000;
            wb_r_we_i = 1;
            wb_c_we_i = 0;

            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 32'h00001000, 32'hDEADBEEF, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wb_data_i = 32'hCAFEBABE;
            wb_addr_i = 32'h00002000;
            wb_r_we_i = 0;
            wb_c_we_i = 1;

            #1;

            #1;


            check_outputs(32'h00002000, 32'hCAFEBABE, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            r_data_i = 32'h12345678;
            c_data_i = 32'h87654321;
            mem_r_read_en = 1;
            mem_c_read_en = 1;

            #1;

            #1;


            check_outputs(0, 0, 0, 32'h87654321, 32'h12345678, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            mem_r_addr_i = 32'h0000ABCD;
            wb_addr_i    = 32'h0000ABCD;
            mem_r_read_en = 1;
            wb_r_we_i    = 1;

            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 32'h0000ABCD, 0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            mem_r_addr_i = 32'h00001111;
            wb_addr_i    = 32'h00002222;
            mem_r_read_en = 1;
            wb_r_we_i    = 1;

            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 32'h00002222, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            mem_r_addr_i = 32'h0000FFFF;
            wb_addr_i    = 32'h0000FFFF;
            mem_r_read_en = 0;
            wb_r_we_i    = 1;

            #1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 32'h0000FFFF, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            wb_data_i = 32'h55AA55AA;
            wb_addr_i = 32'h00003000;
            wb_r_we_i = 1;
            wb_c_we_i = 1;

            #1;

            #1;


            check_outputs(32'h00003000, 32'h55AA55AA, 1, 0, 0, 32'h00003000, 32'h55AA55AA, 0, 1);
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
        input [31:0] expected_c_addr_o;
        input [31:0] expected_c_data_o;
        input expected_c_we_o;
        input [31:0] expected_mem_c_data_o;
        input [31:0] expected_mem_r_data_o;
        input [31:0] expected_r_addr_o;
        input [31:0] expected_r_data_o;
        input expected_r_rw_conflict_o;
        input expected_r_we_o;
        begin
            if (expected_c_addr_o === (expected_c_addr_o ^ c_addr_o ^ expected_c_addr_o) &&
                expected_c_data_o === (expected_c_data_o ^ c_data_o ^ expected_c_data_o) &&
                expected_c_we_o === (expected_c_we_o ^ c_we_o ^ expected_c_we_o) &&
                expected_mem_c_data_o === (expected_mem_c_data_o ^ mem_c_data_o ^ expected_mem_c_data_o) &&
                expected_mem_r_data_o === (expected_mem_r_data_o ^ mem_r_data_o ^ expected_mem_r_data_o) &&
                expected_r_addr_o === (expected_r_addr_o ^ r_addr_o ^ expected_r_addr_o) &&
                expected_r_data_o === (expected_r_data_o ^ r_data_o ^ expected_r_data_o) &&
                expected_r_rw_conflict_o === (expected_r_rw_conflict_o ^ r_rw_conflict_o ^ expected_r_rw_conflict_o) &&
                expected_r_we_o === (expected_r_we_o ^ r_we_o ^ expected_r_we_o)) begin
                $display("PASS");
                $display("  Outputs: c_addr_o=%h, c_data_o=%h, c_we_o=%b, mem_c_data_o=%h, mem_r_data_o=%h, r_addr_o=%h, r_data_o=%h, r_rw_conflict_o=%b, r_we_o=%b",
                         c_addr_o, c_data_o, c_we_o, mem_c_data_o, mem_r_data_o, r_addr_o, r_data_o, r_rw_conflict_o, r_we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_addr_o=%h, c_data_o=%h, c_we_o=%b, mem_c_data_o=%h, mem_r_data_o=%h, r_addr_o=%h, r_data_o=%h, r_rw_conflict_o=%b, r_we_o=%b",
                         expected_c_addr_o, expected_c_data_o, expected_c_we_o, expected_mem_c_data_o, expected_mem_r_data_o, expected_r_addr_o, expected_r_data_o, expected_r_rw_conflict_o, expected_r_we_o);
                $display("  Got:      c_addr_o=%h, c_data_o=%h, c_we_o=%b, mem_c_data_o=%h, mem_r_data_o=%h, r_addr_o=%h, r_data_o=%h, r_rw_conflict_o=%b, r_we_o=%b",
                         c_addr_o, c_data_o, c_we_o, mem_c_data_o, mem_r_data_o, r_addr_o, r_data_o, r_rw_conflict_o, r_we_o);
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
        $dumpvars(0,c_data_i, clk, mem_c_addr_i, mem_c_read_en, mem_r_addr_i, mem_r_read_en, r_data_i, rst, wb_addr_i, wb_c_we_i, wb_data_i, wb_r_we_i, c_addr_o, c_data_o, c_we_o, mem_c_data_o, mem_r_data_o, r_addr_o, r_data_o, r_rw_conflict_o, r_we_o);
    end

endmodule
