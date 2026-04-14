`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg jmp_pc_en_i;
    reg [31:0] jmp_pc_i;
    reg [31:0] p_data_i;
    reg rst;
    reg seq_stop_inc_pc_i;
    wire [31:0] inst_o;
    wire [31:0] p_addr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .jmp_pc_en_i(jmp_pc_en_i),
        .jmp_pc_i(jmp_pc_i),
        .p_data_i(p_data_i),
        .rst(rst),
        .seq_stop_inc_pc_i(seq_stop_inc_pc_i),
        .inst_o(inst_o),
        .p_addr_o(p_addr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            jmp_pc_en_i = 0;
            jmp_pc_i = 32'h0;
            p_data_i = 32'h0;
            seq_stop_inc_pc_i = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Normal Increment (+4)");
            reset_dut();


            p_data_i = 32'hAABBCCDD;
            @(posedge clk); #1;


            p_data_i = 32'h11223344;
            @(posedge clk); #1;


            #1;



            check_outputs(32'h11223344, 32'h00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Jump Operation");
            reset_dut();

            jmp_pc_en_i = 1;
            jmp_pc_i = 32'h0000_1000;
            p_data_i = 32'hDEADBEEF;

            @(posedge clk); #1;



            #1;




            check_outputs(32'hDEADBEEF, 32'h0000_1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Stop PC Increment");
            reset_dut();


            @(posedge clk); #1;


            seq_stop_inc_pc_i = 1;
            p_data_i = 32'h5555_AAAA;
            @(posedge clk); #1;


            #1;



            check_outputs(32'h5555_AAAA, 32'h0000_0004);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Jump Priority over Stop");
            reset_dut();

            seq_stop_inc_pc_i = 1;
            jmp_pc_en_i = 1;
            jmp_pc_i = 32'h0000_F00D;
            p_data_i = 32'h1234_5678;

            @(posedge clk); #1;


            #1;



            check_outputs(32'h1234_5678, 32'h0000_F00D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Consecutive Jumps");
            reset_dut();


            jmp_pc_en_i = 1;
            jmp_pc_i = 32'h0000_0100;
            @(posedge clk); #1;


            jmp_pc_i = 32'h0000_0200;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h0, 32'h0000_0200);
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
        input [31:0] expected_inst_o;
        input [31:0] expected_p_addr_o;
        begin
            if (expected_inst_o === (expected_inst_o ^ inst_o ^ expected_inst_o) &&
                expected_p_addr_o === (expected_p_addr_o ^ p_addr_o ^ expected_p_addr_o)) begin
                $display("PASS");
                $display("  Outputs: inst_o=%h, p_addr_o=%h",
                         inst_o, p_addr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst_o=%h, p_addr_o=%h",
                         expected_inst_o, expected_p_addr_o);
                $display("  Got:      inst_o=%h, p_addr_o=%h",
                         inst_o, p_addr_o);
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
        $dumpvars(0,clk, jmp_pc_en_i, jmp_pc_i, p_data_i, rst, seq_stop_inc_pc_i, inst_o, p_addr_o);
    end

endmodule
