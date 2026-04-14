`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_result_in;
    reg [31:0] Read_data_in;
    reg [4:0] Write_reg_in;
    reg clk;
    reg [1:0] control_wb_in;
    wire [31:0] Read_data;
    wire [31:0] mem_ALU_result;
    wire [4:0] mem_Write_reg;
    wire [1:0] mem_control_wb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_result_in(ALU_result_in),
        .Read_data_in(Read_data_in),
        .Write_reg_in(Write_reg_in),
        .clk(clk),
        .control_wb_in(control_wb_in),
        .Read_data(Read_data),
        .mem_ALU_result(mem_ALU_result),
        .mem_Write_reg(mem_Write_reg),
        .mem_control_wb(mem_control_wb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALU_result_in = 0;
            Read_data_in = 0;
            Write_reg_in = 0;
            control_wb_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Pass-through", test_num);

            control_wb_in = 2'b10;
            Read_data_in = 32'hABCD_1234;
            ALU_result_in = 32'h5555_AAAA;
            Write_reg_in = 5'd10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD_1234, 32'h5555_AAAA, 5'd10, 2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Maximum Values", test_num);

            control_wb_in = 2'b11;
            Read_data_in = 32'hFFFF_FFFF;
            ALU_result_in = 32'hFFFF_FFFF;
            Write_reg_in = 5'b11111;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 5'b11111, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Zero Values", test_num);

            control_wb_in = 2'b00;
            Read_data_in = 32'h0000_0000;
            ALU_result_in = 32'h0000_0000;
            Write_reg_in = 5'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000, 5'd0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Alternating Bits", test_num);

            control_wb_in = 2'b01;
            Read_data_in = 32'hAAAA_AAAA;
            ALU_result_in = 32'h5555_5555;
            Write_reg_in = 5'b10101;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'h5555_5555, 5'b10101, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Register Address Check (Reg 31)", test_num);

            control_wb_in = 2'b10;
            Read_data_in = 32'hDEAD_BEEF;
            ALU_result_in = 32'hCAFE_BABE;
            Write_reg_in = 5'd31;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hCAFE_BABE, 5'd31, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Rapid Sequential Update", test_num);


            control_wb_in = 2'b11;
            Read_data_in = 32'h1;
            ALU_result_in = 32'h2;
            Write_reg_in = 5'd5;
            @(posedge clk);
            #1;


            control_wb_in = 2'b01;
            Read_data_in = 32'h9999_8888;
            ALU_result_in = 32'h7777_6666;
            Write_reg_in = 5'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h9999_8888, 32'h7777_6666, 5'd20, 2'b01);
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
        input [31:0] expected_Read_data;
        input [31:0] expected_mem_ALU_result;
        input [4:0] expected_mem_Write_reg;
        input [1:0] expected_mem_control_wb;
        begin
            if (expected_Read_data === (expected_Read_data ^ Read_data ^ expected_Read_data) &&
                expected_mem_ALU_result === (expected_mem_ALU_result ^ mem_ALU_result ^ expected_mem_ALU_result) &&
                expected_mem_Write_reg === (expected_mem_Write_reg ^ mem_Write_reg ^ expected_mem_Write_reg) &&
                expected_mem_control_wb === (expected_mem_control_wb ^ mem_control_wb ^ expected_mem_control_wb)) begin
                $display("PASS");
                $display("  Outputs: Read_data=%h, mem_ALU_result=%h, mem_Write_reg=%h, mem_control_wb=%h",
                         Read_data, mem_ALU_result, mem_Write_reg, mem_control_wb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Read_data=%h, mem_ALU_result=%h, mem_Write_reg=%h, mem_control_wb=%h",
                         expected_Read_data, expected_mem_ALU_result, expected_mem_Write_reg, expected_mem_control_wb);
                $display("  Got:      Read_data=%h, mem_ALU_result=%h, mem_Write_reg=%h, mem_control_wb=%h",
                         Read_data, mem_ALU_result, mem_Write_reg, mem_control_wb);
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
        $dumpvars(0,ALU_result_in, Read_data_in, Write_reg_in, clk, control_wb_in, Read_data, mem_ALU_result, mem_Write_reg, mem_control_wb);
    end

endmodule
