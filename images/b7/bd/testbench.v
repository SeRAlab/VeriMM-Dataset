`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_rslt_in;
    reg [31:0] Read_data_in;
    reg [4:0] Write_reg_in;
    reg clk;
    reg [1:0] control_wb_in;
    reg data_hit;
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
        .ALU_rslt_in(ALU_rslt_in),
        .Read_data_in(Read_data_in),
        .Write_reg_in(Write_reg_in),
        .clk(clk),
        .control_wb_in(control_wb_in),
        .data_hit(data_hit),
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
            ALU_rslt_in = 32'b0;
            Read_data_in = 32'b0;
            Write_reg_in = 5'b0;
            control_wb_in = 2'b0;
            data_hit = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Basic Data Capture (data_hit = 1)", test_num);

            ALU_rslt_in = 32'hDEADBEEF;
            Read_data_in = 32'h12345678;
            Write_reg_in = 5'h1A;
            control_wb_in = 2'b11;
            data_hit = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h12345678, 32'hDEADBEEF, 5'h1A, 2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Data Hold Logic (data_hit = 0)", test_num);


            ALU_rslt_in = 32'hAAAA_AAAA;
            Read_data_in = 32'hBBBB_BBBB;
            Write_reg_in = 5'h05;
            control_wb_in = 2'b01;
            data_hit = 1;
            @(posedge clk);
            #2;


            ALU_rslt_in = 32'hFFFF_FFFF;
            Read_data_in = 32'h0000_0000;
            Write_reg_in = 5'h1F;
            control_wb_in = 2'b10;
            data_hit = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hBBBB_BBBB, 32'hAAAA_AAAA, 5'h05, 2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Successive Updates", test_num);


            ALU_rslt_in = 32'h1; Read_data_in = 32'h2; Write_reg_in = 5'h3; control_wb_in = 2'b00;
            data_hit = 1;
            @(posedge clk);
            #2;


            ALU_rslt_in = 32'hC0DE_C0DE; Read_data_in = 32'hBABE_BABE; Write_reg_in = 5'h10; control_wb_in = 2'b11;
            data_hit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hBABE_BABE, 32'hC0DE_C0DE, 5'h10, 2'b11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Boundary Values (All ones)", test_num);

            ALU_rslt_in = 32'hFFFF_FFFF;
            Read_data_in = 32'hFFFF_FFFF;
            Write_reg_in = 5'b11111;
            control_wb_in = 2'b11;
            data_hit = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 5'b11111, 2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Intermittent Hit", test_num);


            ALU_rslt_in = 32'h5555_AAAA;
            Read_data_in = 32'hAAAA_5555;
            Write_reg_in = 5'h0F;
            control_wb_in = 2'b10;
            data_hit = 0;

            @(posedge clk);
            #2;

            data_hit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_5555, 32'h5555_AAAA, 5'h0F, 2'b10);
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
        $dumpvars(0,ALU_rslt_in, Read_data_in, Write_reg_in, clk, control_wb_in, data_hit, Read_data, mem_ALU_result, mem_Write_reg, mem_control_wb);
    end

endmodule
