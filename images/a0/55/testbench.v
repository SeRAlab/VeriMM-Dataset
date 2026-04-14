`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUout_i;
    reg MemRead_i;
    reg MemWrite_i;
    reg MemtoReg_i;
    reg RegWrite_i;
    reg clk_i;
    reg [4:0] rd_addr_i;
    reg [31:0] rs2_data_i;
    reg rst_i;
    wire [31:0] ALUout_o;
    wire MemRead_o;
    wire MemWrite_o;
    wire MemtoReg_o;
    wire RegWrite_o;
    wire [4:0] rd_addr_o;
    wire [31:0] rs2_data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUout_i(ALUout_i),
        .MemRead_i(MemRead_i),
        .MemWrite_i(MemWrite_i),
        .MemtoReg_i(MemtoReg_i),
        .RegWrite_i(RegWrite_i),
        .clk_i(clk_i),
        .rd_addr_i(rd_addr_i),
        .rs2_data_i(rs2_data_i),
        .rst_i(rst_i),
        .ALUout_o(ALUout_o),
        .MemRead_o(MemRead_o),
        .MemWrite_o(MemWrite_o),
        .MemtoReg_o(MemtoReg_o),
        .RegWrite_o(RegWrite_o),
        .rd_addr_o(rd_addr_o),
        .rs2_data_o(rs2_data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            ALUout_i = 0;
            MemRead_i = 0;
            MemWrite_i = 0;
            MemtoReg_i = 0;
            RegWrite_i = 0;
            rd_addr_i = 0;
            rs2_data_i = 0;
            #10;
            rst_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Data capture on clock edge");
            reset_dut();


            RegWrite_i = 1;
            MemtoReg_i = 0;
            MemRead_i = 1;
            MemWrite_i = 0;
            ALUout_i = 32'hCAFEBABE;
            rs2_data_i = 32'h12345678;
            rd_addr_i = 5'd10;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(32'hCAFEBABE, 1'b1, 1'b0, 1'b0, 1'b1, 5'd10, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verifying data update over multiple cycles");
            reset_dut();


            RegWrite_i = 1;
            MemtoReg_i = 1;
            MemRead_i = 0;
            MemWrite_i = 0;
            ALUout_i = 32'hAAAA_AAAA;
            rs2_data_i = 32'hBBBB_BBBB;
            rd_addr_i = 5'd31;
            @(posedge clk_i);


            #2;
            RegWrite_i = 0;
            MemtoReg_i = 0;
            MemRead_i = 0;
            MemWrite_i = 1;
            ALUout_i = 32'h5555_5555;
            rs2_data_i = 32'h0;
            rd_addr_i = 5'd5;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(32'h5555_5555, 1'b0, 1'b1, 1'b0, 1'b0, 5'd5, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Asynchronous reset during active operation");
            reset_dut();


            RegWrite_i = 1;
            ALUout_i = 32'hDEADBEEF;
            rd_addr_i = 5'd16;
            @(posedge clk_i);
            #2;


            rst_i = 1;
            #2;


            #1;



            check_outputs(32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Output stability between clock edges");
            reset_dut();


            RegWrite_i = 1;
            ALUout_i = 32'h11112222;
            rd_addr_i = 5'd8;
            @(posedge clk_i);
            #2;


            RegWrite_i = 0;
            ALUout_i = 32'hFFFFFFFF;
            rd_addr_i = 5'd0;
            #4;


            #1;



            check_outputs(32'h11112222, 1'b0, 1'b0, 1'b0, 1'b1, 5'd8, 32'h0);
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
        input [31:0] expected_ALUout_o;
        input expected_MemRead_o;
        input expected_MemWrite_o;
        input expected_MemtoReg_o;
        input expected_RegWrite_o;
        input [4:0] expected_rd_addr_o;
        input [31:0] expected_rs2_data_o;
        begin
            if (expected_ALUout_o === (expected_ALUout_o ^ ALUout_o ^ expected_ALUout_o) &&
                expected_MemRead_o === (expected_MemRead_o ^ MemRead_o ^ expected_MemRead_o) &&
                expected_MemWrite_o === (expected_MemWrite_o ^ MemWrite_o ^ expected_MemWrite_o) &&
                expected_MemtoReg_o === (expected_MemtoReg_o ^ MemtoReg_o ^ expected_MemtoReg_o) &&
                expected_RegWrite_o === (expected_RegWrite_o ^ RegWrite_o ^ expected_RegWrite_o) &&
                expected_rd_addr_o === (expected_rd_addr_o ^ rd_addr_o ^ expected_rd_addr_o) &&
                expected_rs2_data_o === (expected_rs2_data_o ^ rs2_data_o ^ expected_rs2_data_o)) begin
                $display("PASS");
                $display("  Outputs: ALUout_o=%h, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegWrite_o=%b, rd_addr_o=%h, rs2_data_o=%h",
                         ALUout_o, MemRead_o, MemWrite_o, MemtoReg_o, RegWrite_o, rd_addr_o, rs2_data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUout_o=%h, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegWrite_o=%b, rd_addr_o=%h, rs2_data_o=%h",
                         expected_ALUout_o, expected_MemRead_o, expected_MemWrite_o, expected_MemtoReg_o, expected_RegWrite_o, expected_rd_addr_o, expected_rs2_data_o);
                $display("  Got:      ALUout_o=%h, MemRead_o=%b, MemWrite_o=%b, MemtoReg_o=%b, RegWrite_o=%b, rd_addr_o=%h, rs2_data_o=%h",
                         ALUout_o, MemRead_o, MemWrite_o, MemtoReg_o, RegWrite_o, rd_addr_o, rs2_data_o);
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
        $dumpvars(0,ALUout_i, MemRead_i, MemWrite_i, MemtoReg_i, RegWrite_i, clk_i, rd_addr_i, rs2_data_i, rst_i, ALUout_o, MemRead_o, MemWrite_o, MemtoReg_o, RegWrite_o, rd_addr_o, rs2_data_o);
    end

endmodule
