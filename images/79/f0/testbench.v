`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALU_OUT_EX;
    reg [2:0] M_EX;
    reg [31:0] PC_Branch_EX;
    reg [4:0] RD_EX;
    reg [31:0] REG_DATA2_EX_FINAL;
    reg [1:0] WB_EX;
    reg ZERO_EX;
    reg clk;
    reg reset;
    wire [31:0] ALU_OUT_MEM;
    wire [2:0] M_MEM;
    wire [31:0] PC_Branch_MEM;
    wire [4:0] RD_MEM;
    wire [31:0] REG_DATA2_MEM_FINAL;
    wire [1:0] WB_MEM;
    wire ZERO_MEM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_OUT_EX(ALU_OUT_EX),
        .M_EX(M_EX),
        .PC_Branch_EX(PC_Branch_EX),
        .RD_EX(RD_EX),
        .REG_DATA2_EX_FINAL(REG_DATA2_EX_FINAL),
        .WB_EX(WB_EX),
        .ZERO_EX(ZERO_EX),
        .clk(clk),
        .reset(reset),
        .ALU_OUT_MEM(ALU_OUT_MEM),
        .M_MEM(M_MEM),
        .PC_Branch_MEM(PC_Branch_MEM),
        .RD_MEM(RD_MEM),
        .REG_DATA2_MEM_FINAL(REG_DATA2_MEM_FINAL),
        .WB_MEM(WB_MEM),
        .ZERO_MEM(ZERO_MEM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ZERO_EX = 0;
            ALU_OUT_EX = 0;
            PC_Branch_EX = 0;
            REG_DATA2_EX_FINAL = 0;
            WB_EX = 0;
            M_EX = 0;
            RD_EX = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Initial Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 3'h0, 32'h0, 5'h0, 32'h0, 2'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Basic Data Transfer", test_num);
            reset_dut();


            ZERO_EX = 1'b1;
            ALU_OUT_EX = 32'hDEADBEEF;
            PC_Branch_EX = 32'h00001000;
            REG_DATA2_EX_FINAL = 32'hCAFEF00D;
            WB_EX = 2'b10;
            M_EX = 3'b101;
            RD_EX = 5'd15;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 3'b101, 32'h00001000, 5'd15, 32'hCAFEF00D, 2'b10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Pattern Transfer", test_num);
            reset_dut();


            ZERO_EX = 1'b0;
            ALU_OUT_EX = 32'hAAAA5555;
            PC_Branch_EX = 32'hFFFF0000;
            REG_DATA2_EX_FINAL = 32'h12345678;
            WB_EX = 2'b01;
            M_EX = 3'b010;
            RD_EX = 5'd31;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA5555, 3'b010, 32'hFFFF0000, 5'd31, 32'h12345678, 2'b01, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Synchronous Reset with active inputs", test_num);
            reset_dut();


            ZERO_EX = 1'b1;
            ALU_OUT_EX = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;


            #1;



            check_outputs(32'h0, 3'h0, 32'h0, 5'h0, 32'h0, 2'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: All Ones Boundary Check", test_num);
            reset_dut();

            ZERO_EX = 1'b1;
            ALU_OUT_EX = 32'hFFFFFFFF;
            PC_Branch_EX = 32'hFFFFFFFF;
            REG_DATA2_EX_FINAL = 32'hFFFFFFFF;
            WB_EX = 2'b11;
            M_EX = 3'b111;
            RD_EX = 5'b11111;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 3'b111, 32'hFFFFFFFF, 5'b11111, 32'hFFFFFFFF, 2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Timing/Pipeline Edge Check", test_num);
            reset_dut();


            ZERO_EX = 1'b0;
            ALU_OUT_EX = 32'hBADC0DE1;
            @(posedge clk);
            #2;


            ZERO_EX = 1'b1;
            ALU_OUT_EX = 32'h0;
            #2;


            #1;



            check_outputs(32'hBADC0DE1, 3'h0, 32'h0, 5'h0, 32'h0, 2'h0, 1'b0);


            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h0, 3'h0, 32'h0, 5'h0, 32'h0, 2'h0, 1'b1);
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
        input [31:0] expected_ALU_OUT_MEM;
        input [2:0] expected_M_MEM;
        input [31:0] expected_PC_Branch_MEM;
        input [4:0] expected_RD_MEM;
        input [31:0] expected_REG_DATA2_MEM_FINAL;
        input [1:0] expected_WB_MEM;
        input expected_ZERO_MEM;
        begin
            if (expected_ALU_OUT_MEM === (expected_ALU_OUT_MEM ^ ALU_OUT_MEM ^ expected_ALU_OUT_MEM) &&
                expected_M_MEM === (expected_M_MEM ^ M_MEM ^ expected_M_MEM) &&
                expected_PC_Branch_MEM === (expected_PC_Branch_MEM ^ PC_Branch_MEM ^ expected_PC_Branch_MEM) &&
                expected_RD_MEM === (expected_RD_MEM ^ RD_MEM ^ expected_RD_MEM) &&
                expected_REG_DATA2_MEM_FINAL === (expected_REG_DATA2_MEM_FINAL ^ REG_DATA2_MEM_FINAL ^ expected_REG_DATA2_MEM_FINAL) &&
                expected_WB_MEM === (expected_WB_MEM ^ WB_MEM ^ expected_WB_MEM) &&
                expected_ZERO_MEM === (expected_ZERO_MEM ^ ZERO_MEM ^ expected_ZERO_MEM)) begin
                $display("PASS");
                $display("  Outputs: ALU_OUT_MEM=%h, M_MEM=%h, PC_Branch_MEM=%h, RD_MEM=%h, REG_DATA2_MEM_FINAL=%h, WB_MEM=%h, ZERO_MEM=%b",
                         ALU_OUT_MEM, M_MEM, PC_Branch_MEM, RD_MEM, REG_DATA2_MEM_FINAL, WB_MEM, ZERO_MEM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_OUT_MEM=%h, M_MEM=%h, PC_Branch_MEM=%h, RD_MEM=%h, REG_DATA2_MEM_FINAL=%h, WB_MEM=%h, ZERO_MEM=%b",
                         expected_ALU_OUT_MEM, expected_M_MEM, expected_PC_Branch_MEM, expected_RD_MEM, expected_REG_DATA2_MEM_FINAL, expected_WB_MEM, expected_ZERO_MEM);
                $display("  Got:      ALU_OUT_MEM=%h, M_MEM=%h, PC_Branch_MEM=%h, RD_MEM=%h, REG_DATA2_MEM_FINAL=%h, WB_MEM=%h, ZERO_MEM=%b",
                         ALU_OUT_MEM, M_MEM, PC_Branch_MEM, RD_MEM, REG_DATA2_MEM_FINAL, WB_MEM, ZERO_MEM);
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
        $dumpvars(0,ALU_OUT_EX, M_EX, PC_Branch_EX, RD_EX, REG_DATA2_EX_FINAL, WB_EX, ZERO_EX, clk, reset, ALU_OUT_MEM, M_MEM, PC_Branch_MEM, RD_MEM, REG_DATA2_MEM_FINAL, WB_MEM, ZERO_MEM);
    end

endmodule
