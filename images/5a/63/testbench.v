`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] branch_addr;
    reg clk;
    reg [31:0] i_instr_in;
    reg if_id_write_en;
    reg [31:0] jump_addr;
    reg [1:0] pc_source;
    reg pc_write;
    reg pstop_i;
    reg rst;
    wire [31:0] IF_ID_instruction;
    wire [31:0] IF_ID_next_i_addr;
    wire [31:0] i_addr;
    wire i_read_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_addr(branch_addr),
        .clk(clk),
        .i_instr_in(i_instr_in),
        .if_id_write_en(if_id_write_en),
        .jump_addr(jump_addr),
        .pc_source(pc_source),
        .pc_write(pc_write),
        .pstop_i(pstop_i),
        .rst(rst),
        .IF_ID_instruction(IF_ID_instruction),
        .IF_ID_next_i_addr(IF_ID_next_i_addr),
        .i_addr(i_addr),
        .i_read_en(i_read_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            branch_addr = 0;
            i_instr_in = 0;
            if_id_write_en = 0;
            jump_addr = 0;
            pc_source = 0;
            pc_write = 0;
            pstop_i = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset check");
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sequential Fetching");
            reset_dut();
            pc_write = 1;
            if_id_write_en = 1;
            pc_source = 2'b00;
            i_instr_in = 32'hDEADBEEF;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hDEADBEEF, 32'h0, 32'h4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: PC Write Disable (Stall)");
            reset_dut();
            pc_write = 0;
            pc_source = 2'b00;
            i_instr_in = 32'h12345678;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Branch Update");
            reset_dut();
            pc_write = 1;
            pc_source = 2'b01;
            branch_addr = 32'h00000100;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Jump Update");
            reset_dut();
            pc_write = 1;
            pc_source = 2'b10;
            jump_addr = 32'h00000ABC;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'hABC, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: IF_ID Write Enable Check");
            reset_dut();
            pc_write = 1;
            if_id_write_en = 0;
            i_instr_in = 32'hCAFEBABE;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Pipeline Stop Signal");
            reset_dut();
            pstop_i = 1;
            pc_write = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_IF_ID_instruction;
        input [31:0] expected_IF_ID_next_i_addr;
        input [31:0] expected_i_addr;
        input expected_i_read_en;
        begin
            if (expected_IF_ID_instruction === (expected_IF_ID_instruction ^ IF_ID_instruction ^ expected_IF_ID_instruction) &&
                expected_IF_ID_next_i_addr === (expected_IF_ID_next_i_addr ^ IF_ID_next_i_addr ^ expected_IF_ID_next_i_addr) &&
                expected_i_addr === (expected_i_addr ^ i_addr ^ expected_i_addr) &&
                expected_i_read_en === (expected_i_read_en ^ i_read_en ^ expected_i_read_en)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_instruction=%h, IF_ID_next_i_addr=%h, i_addr=%h, i_read_en=%b",
                         IF_ID_instruction, IF_ID_next_i_addr, i_addr, i_read_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_instruction=%h, IF_ID_next_i_addr=%h, i_addr=%h, i_read_en=%b",
                         expected_IF_ID_instruction, expected_IF_ID_next_i_addr, expected_i_addr, expected_i_read_en);
                $display("  Got:      IF_ID_instruction=%h, IF_ID_next_i_addr=%h, i_addr=%h, i_read_en=%b",
                         IF_ID_instruction, IF_ID_next_i_addr, i_addr, i_read_en);
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
        $dumpvars(0,branch_addr, clk, i_instr_in, if_id_write_en, jump_addr, pc_source, pc_write, pstop_i, rst, IF_ID_instruction, IF_ID_next_i_addr, i_addr, i_read_en);
    end

endmodule
