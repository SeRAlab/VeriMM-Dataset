`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] B;
    reg [31:0] alu_result;
    reg clk;
    reg [31:0] d_data_in;
    reg [4:0] dst_reg;
    reg mem_read;
    reg mem_write;
    reg pstop_i;
    reg rst;
    reg wb_mem_to_reg;
    reg wb_reg_write;
    wire [31:0] MEM_WB_alu_out;
    wire [4:0] MEM_WB_dst_reg;
    wire [31:0] MEM_WB_mem_out;
    wire MEM_WB_mem_to_reg;
    wire MEM_WB_reg_write;
    wire [31:0] d_addr;
    wire d_read_en;
    wire [31:0] d_write_data;
    wire d_write_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .alu_result(alu_result),
        .clk(clk),
        .d_data_in(d_data_in),
        .dst_reg(dst_reg),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .pstop_i(pstop_i),
        .rst(rst),
        .wb_mem_to_reg(wb_mem_to_reg),
        .wb_reg_write(wb_reg_write),
        .MEM_WB_alu_out(MEM_WB_alu_out),
        .MEM_WB_dst_reg(MEM_WB_dst_reg),
        .MEM_WB_mem_out(MEM_WB_mem_out),
        .MEM_WB_mem_to_reg(MEM_WB_mem_to_reg),
        .MEM_WB_reg_write(MEM_WB_reg_write),
        .d_addr(d_addr),
        .d_read_en(d_read_en),
        .d_write_data(d_write_data),
        .d_write_en(d_write_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk = 0;
            pstop_i = 0;
            mem_read = 0;
            mem_write = 0;
            alu_result = 0;
            B = 0;
            dst_reg = 0;
            wb_reg_write = 0;
            wb_mem_to_reg = 0;
            d_data_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(32'h0, 5'h0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(negedge clk);
            mem_read = 1;
            mem_write = 0;
            alu_result = 32'h0000_1000;
            dst_reg = 5'd10;
            wb_reg_write = 1;
            wb_mem_to_reg = 1;
            d_data_in = 32'hABCD_1234;

            @(posedge clk);
            #2;









            #1;










            check_outputs(32'h0000_1000, 5'd10, 32'hABCD_1234, 1'b1, 1'b1, 32'h0000_1000, 1'b1, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clk);
            mem_read = 0;
            mem_write = 1;
            alu_result = 32'h0000_2000;
            B = 32'h5555_AAAA;
            dst_reg = 5'd0;
            wb_reg_write = 0;
            wb_mem_to_reg = 0;

            @(posedge clk);
            #2;




            #1;





            check_outputs(32'h0000_2000, 5'd0, 32'h0, 1'b0, 1'b0, 32'h0000_2000, 1'b0, 32'h5555_AAAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(negedge clk);
            alu_result = 32'h1111_1111;
            dst_reg = 5'd1;
            wb_reg_write = 1;
            @(posedge clk);
            #2;


            @(negedge clk);
            pstop_i = 1;
            alu_result = 32'hEEEE_EEEE;
            dst_reg = 5'd31;
            @(posedge clk);
            #2;




            if (MEM_WB_alu_out == 32'h1111_1111 && MEM_WB_dst_reg == 5'd1) begin
                pass_count = pass_count + 1;
                $display("PASS: Stall preserved register state.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Stall failed. Expected 11111111, Got %h", MEM_WB_alu_out);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            mem_read = 0;
            mem_write = 0;
            alu_result = 32'h7777_8888;
            dst_reg = 5'd15;
            wb_reg_write = 1;
            wb_mem_to_reg = 0;

            @(posedge clk);
            #2;




            #1;





            check_outputs(32'h7777_8888, 5'd15, 32'h0, 1'b0, 1'b1, 32'h7777_8888, 1'b0, 32'h0, 1'b0);
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
        input [31:0] expected_MEM_WB_alu_out;
        input [4:0] expected_MEM_WB_dst_reg;
        input [31:0] expected_MEM_WB_mem_out;
        input expected_MEM_WB_mem_to_reg;
        input expected_MEM_WB_reg_write;
        input [31:0] expected_d_addr;
        input expected_d_read_en;
        input [31:0] expected_d_write_data;
        input expected_d_write_en;
        begin
            if (expected_MEM_WB_alu_out === (expected_MEM_WB_alu_out ^ MEM_WB_alu_out ^ expected_MEM_WB_alu_out) &&
                expected_MEM_WB_dst_reg === (expected_MEM_WB_dst_reg ^ MEM_WB_dst_reg ^ expected_MEM_WB_dst_reg) &&
                expected_MEM_WB_mem_out === (expected_MEM_WB_mem_out ^ MEM_WB_mem_out ^ expected_MEM_WB_mem_out) &&
                expected_MEM_WB_mem_to_reg === (expected_MEM_WB_mem_to_reg ^ MEM_WB_mem_to_reg ^ expected_MEM_WB_mem_to_reg) &&
                expected_MEM_WB_reg_write === (expected_MEM_WB_reg_write ^ MEM_WB_reg_write ^ expected_MEM_WB_reg_write) &&
                expected_d_addr === (expected_d_addr ^ d_addr ^ expected_d_addr) &&
                expected_d_read_en === (expected_d_read_en ^ d_read_en ^ expected_d_read_en) &&
                expected_d_write_data === (expected_d_write_data ^ d_write_data ^ expected_d_write_data) &&
                expected_d_write_en === (expected_d_write_en ^ d_write_en ^ expected_d_write_en)) begin
                $display("PASS");
                $display("  Outputs: MEM_WB_alu_out=%h, MEM_WB_dst_reg=%h, MEM_WB_mem_out=%h, MEM_WB_mem_to_reg=%b, MEM_WB_reg_write=%b, d_addr=%h, d_read_en=%b, d_write_data=%h, d_write_en=%b",
                         MEM_WB_alu_out, MEM_WB_dst_reg, MEM_WB_mem_out, MEM_WB_mem_to_reg, MEM_WB_reg_write, d_addr, d_read_en, d_write_data, d_write_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEM_WB_alu_out=%h, MEM_WB_dst_reg=%h, MEM_WB_mem_out=%h, MEM_WB_mem_to_reg=%b, MEM_WB_reg_write=%b, d_addr=%h, d_read_en=%b, d_write_data=%h, d_write_en=%b",
                         expected_MEM_WB_alu_out, expected_MEM_WB_dst_reg, expected_MEM_WB_mem_out, expected_MEM_WB_mem_to_reg, expected_MEM_WB_reg_write, expected_d_addr, expected_d_read_en, expected_d_write_data, expected_d_write_en);
                $display("  Got:      MEM_WB_alu_out=%h, MEM_WB_dst_reg=%h, MEM_WB_mem_out=%h, MEM_WB_mem_to_reg=%b, MEM_WB_reg_write=%b, d_addr=%h, d_read_en=%b, d_write_data=%h, d_write_en=%b",
                         MEM_WB_alu_out, MEM_WB_dst_reg, MEM_WB_mem_out, MEM_WB_mem_to_reg, MEM_WB_reg_write, d_addr, d_read_en, d_write_data, d_write_en);
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
        $dumpvars(0,B, alu_result, clk, d_data_in, dst_reg, mem_read, mem_write, pstop_i, rst, wb_mem_to_reg, wb_reg_write, MEM_WB_alu_out, MEM_WB_dst_reg, MEM_WB_mem_out, MEM_WB_mem_to_reg, MEM_WB_reg_write, d_addr, d_read_en, d_write_data, d_write_en);
    end

endmodule
