`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ex_in;
    reg [3:0] funct4_in;
    reg [63:0] imm_data_in;
    reg [2:0] m_in;
    reg [63:0] pc_in;
    reg [4:0] rd_in;
    reg [63:0] read_data1_in;
    reg [63:0] read_data2_in;
    reg [4:0] rs1_in;
    reg [4:0] rs2_in;
    reg [1:0] wb_in;
    wire [2:0] ex_out;
    wire [3:0] funct4_out;
    wire [63:0] imm_data_out;
    wire [2:0] m_out;
    wire [63:0] pc_out;
    wire [4:0] rd_out;
    wire [63:0] read_data1_out;
    wire [63:0] read_data2_out;
    wire [4:0] rs1_out;
    wire [4:0] rs2_out;
    wire [1:0] wb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ex_in(ex_in),
        .funct4_in(funct4_in),
        .imm_data_in(imm_data_in),
        .m_in(m_in),
        .pc_in(pc_in),
        .rd_in(rd_in),
        .read_data1_in(read_data1_in),
        .read_data2_in(read_data2_in),
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .wb_in(wb_in),
        .ex_out(ex_out),
        .funct4_out(funct4_out),
        .imm_data_out(imm_data_out),
        .m_out(m_out),
        .pc_out(pc_out),
        .rd_out(rd_out),
        .read_data1_out(read_data1_out),
        .read_data2_out(read_data2_out),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .wb_out(wb_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pc_in = 64'd0;
            imm_data_in = 64'd0;
            read_data1_in = 64'd0;
            read_data2_in = 64'd0;
            rs1_in = 5'd0;
            rs2_in = 5'd0;
            rd_in = 5'd0;
            funct4_in = 4'd0;
            wb_in = 2'd0;
            m_in = 3'd0;
            ex_in = 3'd0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Standard Values Capture");
            reset_dut();

            pc_in         = 64'h0000_0000_ABCD_1234;
            imm_data_in   = 64'hFFFF_FFFF_0000_1111;
            read_data1_in = 64'h1122_3344_5566_7788;
            read_data2_in = 64'h8877_6655_4433_2211;
            rs1_in        = 5'd5;
            rs2_in        = 5'd10;
            rd_in         = 5'd15;
            funct4_in     = 4'hA;
            wb_in         = 2'b10;
            m_in          = 3'b110;
            ex_in         = 3'b011;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b011, 4'hA, 64'hFFFF_FFFF_0000_1111, 3'b110, 64'h0000_0000_ABCD_1234, 5'd15, 64'h1122_3344_5566_7788, 64'h8877_6655_4433_2211, 5'd5, 5'd10, 2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Maximum Values Capture");
            reset_dut();

            pc_in         = 64'hFFFF_FFFF_FFFF_FFFF;
            imm_data_in   = 64'hFFFF_FFFF_FFFF_FFFF;
            read_data1_in = 64'hFFFF_FFFF_FFFF_FFFF;
            read_data2_in = 64'hFFFF_FFFF_FFFF_FFFF;
            rs1_in        = 5'h1F;
            rs2_in        = 5'h1F;
            rd_in         = 5'h1F;
            funct4_in     = 4'hF;
            wb_in         = 2'h3;
            m_in          = 3'h7;
            ex_in         = 3'h7;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'h7, 4'hF, 64'hFFFF_FFFF_FFFF_FFFF, 3'h7, 64'hFFFF_FFFF_FFFF_FFFF, 5'h1F, 64'hFFFF_FFFF_FFFF_FFFF, 64'hFFFF_FFFF_FFFF_FFFF, 5'h1F, 5'h1F, 2'h3);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Checkerboard Patterns");
            reset_dut();

            pc_in         = 64'hAAAA_AAAA_AAAA_AAAA;
            imm_data_in   = 64'h5555_5555_5555_5555;
            read_data1_in = 64'hAAAA_AAAA_AAAA_AAAA;
            read_data2_in = 64'h5555_5555_5555_5555;
            rs1_in        = 5'b10101;
            rs2_in        = 5'b01010;
            rd_in         = 5'b10101;
            funct4_in     = 4'b1010;
            wb_in         = 2'b01;
            m_in          = 3'b101;
            ex_in         = 3'b010;

            @(posedge clk);
            #2;
            #1;

            check_outputs(3'b010, 4'b1010, 64'h5555_5555_5555_5555, 3'b101, 64'hAAAA_AAAA_AAAA_AAAA, 5'b10101, 64'hAAAA_AAAA_AAAA_AAAA, 64'h5555_5555_5555_5555, 5'b10101, 5'b01010, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Timing and Stability Check");
            reset_dut();


            pc_in         = 64'h1;
            imm_data_in   = 64'h2;
            read_data1_in = 64'h3;
            read_data2_in = 64'h4;
            rs1_in        = 5'd1;
            rs2_in        = 5'd2;
            rd_in         = 5'd3;
            funct4_in     = 4'h1;
            wb_in         = 2'd1;
            m_in          = 3'd1;
            ex_in         = 3'd1;

            @(posedge clk);
            #2;


            pc_in         = 64'h999;
            imm_data_in   = 64'h888;


            #1;



            check_outputs(3'd1, 4'h1, 64'h2, 3'd1, 64'h1, 5'd3, 64'h3, 64'h4, 5'd1, 5'd2, 2'd1);


            @(posedge clk);
            #2;


            #1;



            check_outputs(3'd1, 4'h1, 64'h888, 3'd1, 64'h999, 5'd3, 64'h3, 64'h4, 5'd1, 5'd2, 2'd1);
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
        input [2:0] expected_ex_out;
        input [3:0] expected_funct4_out;
        input [63:0] expected_imm_data_out;
        input [2:0] expected_m_out;
        input [63:0] expected_pc_out;
        input [4:0] expected_rd_out;
        input [63:0] expected_read_data1_out;
        input [63:0] expected_read_data2_out;
        input [4:0] expected_rs1_out;
        input [4:0] expected_rs2_out;
        input [1:0] expected_wb_out;
        begin
            if (expected_ex_out === (expected_ex_out ^ ex_out ^ expected_ex_out) &&
                expected_funct4_out === (expected_funct4_out ^ funct4_out ^ expected_funct4_out) &&
                expected_imm_data_out === (expected_imm_data_out ^ imm_data_out ^ expected_imm_data_out) &&
                expected_m_out === (expected_m_out ^ m_out ^ expected_m_out) &&
                expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_rd_out === (expected_rd_out ^ rd_out ^ expected_rd_out) &&
                expected_read_data1_out === (expected_read_data1_out ^ read_data1_out ^ expected_read_data1_out) &&
                expected_read_data2_out === (expected_read_data2_out ^ read_data2_out ^ expected_read_data2_out) &&
                expected_rs1_out === (expected_rs1_out ^ rs1_out ^ expected_rs1_out) &&
                expected_rs2_out === (expected_rs2_out ^ rs2_out ^ expected_rs2_out) &&
                expected_wb_out === (expected_wb_out ^ wb_out ^ expected_wb_out)) begin
                $display("PASS");
                $display("  Outputs: ex_out=%h, funct4_out=%h, imm_data_out=%h, m_out=%h, pc_out=%h, rd_out=%h, read_data1_out=%h, read_data2_out=%h, rs1_out=%h, rs2_out=%h, wb_out=%h",
                         ex_out, funct4_out, imm_data_out, m_out, pc_out, rd_out, read_data1_out, read_data2_out, rs1_out, rs2_out, wb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_out=%h, funct4_out=%h, imm_data_out=%h, m_out=%h, pc_out=%h, rd_out=%h, read_data1_out=%h, read_data2_out=%h, rs1_out=%h, rs2_out=%h, wb_out=%h",
                         expected_ex_out, expected_funct4_out, expected_imm_data_out, expected_m_out, expected_pc_out, expected_rd_out, expected_read_data1_out, expected_read_data2_out, expected_rs1_out, expected_rs2_out, expected_wb_out);
                $display("  Got:      ex_out=%h, funct4_out=%h, imm_data_out=%h, m_out=%h, pc_out=%h, rd_out=%h, read_data1_out=%h, read_data2_out=%h, rs1_out=%h, rs2_out=%h, wb_out=%h",
                         ex_out, funct4_out, imm_data_out, m_out, pc_out, rd_out, read_data1_out, read_data2_out, rs1_out, rs2_out, wb_out);
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
        $dumpvars(0,clk, ex_in, funct4_in, imm_data_in, m_in, pc_in, rd_in, read_data1_in, read_data2_in, rs1_in, rs2_in, wb_in, ex_out, funct4_out, imm_data_out, m_out, pc_out, rd_out, read_data1_out, read_data2_out, rs1_out, rs2_out, wb_out);
    end

endmodule
