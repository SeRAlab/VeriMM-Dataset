`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] id_Aluc;
    reg id_LW;
    reg id_WMEM;
    reg id_WREG;
    reg [31:0] id_a;
    reg [31:0] id_b;
    reg [31:0] id_d2;
    reg [31:0] id_instr;
    reg [4:0] id_td;
    reg rst;
    wire [4:0] ex_Aluc;
    wire ex_LW;
    wire ex_WMEM;
    wire ex_WREG;
    wire [31:0] ex_a;
    wire [31:0] ex_b;
    wire [31:0] ex_d2;
    wire [31:0] ex_instr;
    wire [4:0] ex_td;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .id_Aluc(id_Aluc),
        .id_LW(id_LW),
        .id_WMEM(id_WMEM),
        .id_WREG(id_WREG),
        .id_a(id_a),
        .id_b(id_b),
        .id_d2(id_d2),
        .id_instr(id_instr),
        .id_td(id_td),
        .rst(rst),
        .ex_Aluc(ex_Aluc),
        .ex_LW(ex_LW),
        .ex_WMEM(ex_WMEM),
        .ex_WREG(ex_WREG),
        .ex_a(ex_a),
        .ex_b(ex_b),
        .ex_d2(ex_d2),
        .ex_instr(ex_instr),
        .ex_td(ex_td)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            id_Aluc = 0;
            id_LW = 0;
            id_WMEM = 0;
            id_WREG = 0;
            id_a = 0;
            id_b = 0;
            id_d2 = 0;
            id_instr = 0;
            id_td = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Power-on Reset check");
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple data propagation");
            reset_dut();
            test_num = 2;

            @(negedge clk);
            id_a = 32'hDEADBEEF;
            id_b = 32'hCAFEBABE;
            id_d2 = 32'h12345678;
            id_instr = 32'h87654321;
            id_td = 5'd15;
            id_Aluc = 5'b10101;
            id_WREG = 1'b1;
            id_WMEM = 1'b0;
            id_LW = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'b10101, 1'b1, 1'b0, 1'b1, 32'hDEADBEEF, 32'hCAFEBABE, 32'h12345678, 32'h87654321, 5'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternate data pattern");
            reset_dut();
            test_num = 3;

            @(negedge clk);
            id_a = 32'h55555555;
            id_b = 32'hAAAAAAAA;
            id_d2 = 32'h0F0F0F0F;
            id_instr = 32'hF0F0F0F0;
            id_td = 5'd31;
            id_Aluc = 5'b01010;
            id_WREG = 1'b0;
            id_WMEM = 1'b1;
            id_LW = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b01010, 1'b0, 1'b1, 1'b0, 32'h55555555, 32'hAAAAAAAA, 32'h0F0F0F0F, 32'hF0F0F0F0, 5'd31);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reset mid-operation");
            reset_dut();
            test_num = 4;


            @(negedge clk);
            id_a = 32'hFFFFFFFF;
            id_td = 5'd10;
            @(posedge clk);
            #2;


            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;


            #1;



            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero inputs propagation");
            reset_dut();
            test_num = 5;

            @(negedge clk);
            id_a = 32'h0;
            id_b = 32'h0;
            id_d2 = 32'h0;
            id_instr = 32'h0;
            id_td = 5'h0;
            id_Aluc = 5'h0;
            id_WREG = 1'b0;
            id_WMEM = 1'b0;
            id_LW = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h0, 1'b0, 1'b0, 1'b0, 32'h0, 32'h0, 32'h0, 32'h0, 5'h0);
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
        input [4:0] expected_ex_Aluc;
        input expected_ex_LW;
        input expected_ex_WMEM;
        input expected_ex_WREG;
        input [31:0] expected_ex_a;
        input [31:0] expected_ex_b;
        input [31:0] expected_ex_d2;
        input [31:0] expected_ex_instr;
        input [4:0] expected_ex_td;
        begin
            if (expected_ex_Aluc === (expected_ex_Aluc ^ ex_Aluc ^ expected_ex_Aluc) &&
                expected_ex_LW === (expected_ex_LW ^ ex_LW ^ expected_ex_LW) &&
                expected_ex_WMEM === (expected_ex_WMEM ^ ex_WMEM ^ expected_ex_WMEM) &&
                expected_ex_WREG === (expected_ex_WREG ^ ex_WREG ^ expected_ex_WREG) &&
                expected_ex_a === (expected_ex_a ^ ex_a ^ expected_ex_a) &&
                expected_ex_b === (expected_ex_b ^ ex_b ^ expected_ex_b) &&
                expected_ex_d2 === (expected_ex_d2 ^ ex_d2 ^ expected_ex_d2) &&
                expected_ex_instr === (expected_ex_instr ^ ex_instr ^ expected_ex_instr) &&
                expected_ex_td === (expected_ex_td ^ ex_td ^ expected_ex_td)) begin
                $display("PASS");
                $display("  Outputs: ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_td=%h",
                         ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_td);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_td=%h",
                         expected_ex_Aluc, expected_ex_LW, expected_ex_WMEM, expected_ex_WREG, expected_ex_a, expected_ex_b, expected_ex_d2, expected_ex_instr, expected_ex_td);
                $display("  Got:      ex_Aluc=%h, ex_LW=%b, ex_WMEM=%b, ex_WREG=%b, ex_a=%h, ex_b=%h, ex_d2=%h, ex_instr=%h, ex_td=%h",
                         ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_td);
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
        $dumpvars(0,clk, id_Aluc, id_LW, id_WMEM, id_WREG, id_a, id_b, id_d2, id_instr, id_td, rst, ex_Aluc, ex_LW, ex_WMEM, ex_WREG, ex_a, ex_b, ex_d2, ex_instr, ex_td);
    end

endmodule
