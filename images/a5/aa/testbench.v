`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUOutM;
    reg [1:0] MemAddrE;
    reg [31:0] ReadDataM;
    reg clk;
    reg [31:0] instrM;
    reg [31:0] pcplusM;
    reg rst;
    wire [31:0] ALUOutW;
    wire [1:0] MemAddrW;
    wire [31:0] ReadDataW;
    wire [31:0] instrW;
    wire [31:0] pcplusW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutM(ALUOutM),
        .MemAddrE(MemAddrE),
        .ReadDataM(ReadDataM),
        .clk(clk),
        .instrM(instrM),
        .pcplusM(pcplusM),
        .rst(rst),
        .ALUOutW(ALUOutW),
        .MemAddrW(MemAddrW),
        .ReadDataW(ReadDataW),
        .instrW(instrW),
        .pcplusW(pcplusW)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instrM = 0;
            MemAddrE = 0;
            ReadDataM = 0;
            ALUOutM = 0;
            pcplusM = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();



            #1;




            check_outputs(32'h0, 2'b00, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Data Capture", test_num);
            reset_dut();

            instrM = 32'hDEADBEEF;
            MemAddrE = 2'b10;
            ReadDataM = 32'h12345678;
            ALUOutM = 32'h87654321;
            pcplusM = 32'h00001004;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h87654321, 2'b10, 32'h12345678, 32'hDEADBEEF, 32'h00001004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Edge Values (All Ones)", test_num);
            reset_dut();

            instrM = 32'hFFFFFFFF;
            MemAddrE = 2'b11;
            ReadDataM = 32'hFFFFFFFF;
            ALUOutM = 32'hFFFFFFFF;
            pcplusM = 32'hFFFFFFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 2'b11, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bit Patterns (0xAAAA/0x5555)", test_num);
            reset_dut();

            instrM = 32'hAAAAAAAA;
            MemAddrE = 2'b01;
            ReadDataM = 32'h55555555;
            ALUOutM = 32'hAAAAAAAA;
            pcplusM = 32'h55555555;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 2'b01, 32'h55555555, 32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Successive Data Updates", test_num);
            reset_dut();


            instrM = 32'h11111111;
            MemAddrE = 2'b00;
            ReadDataM = 32'h22222222;
            ALUOutM = 32'h33333333;
            pcplusM = 32'h44444444;
            @(posedge clk);
            #2;


            instrM = 32'hBBBBBBBB;
            MemAddrE = 2'b11;
            ReadDataM = 32'hCCCCCCCC;
            ALUOutM = 32'hDDDDDDDD;
            pcplusM = 32'hEEEEEEEE;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hDDDDDDDD, 2'b11, 32'hCCCCCCCC, 32'hBBBBBBBB, 32'hEEEEEEEE);
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
        input [31:0] expected_ALUOutW;
        input [1:0] expected_MemAddrW;
        input [31:0] expected_ReadDataW;
        input [31:0] expected_instrW;
        input [31:0] expected_pcplusW;
        begin
            if (expected_ALUOutW === (expected_ALUOutW ^ ALUOutW ^ expected_ALUOutW) &&
                expected_MemAddrW === (expected_MemAddrW ^ MemAddrW ^ expected_MemAddrW) &&
                expected_ReadDataW === (expected_ReadDataW ^ ReadDataW ^ expected_ReadDataW) &&
                expected_instrW === (expected_instrW ^ instrW ^ expected_instrW) &&
                expected_pcplusW === (expected_pcplusW ^ pcplusW ^ expected_pcplusW)) begin
                $display("PASS");
                $display("  Outputs: ALUOutW=%h, MemAddrW=%h, ReadDataW=%h, instrW=%h, pcplusW=%h",
                         ALUOutW, MemAddrW, ReadDataW, instrW, pcplusW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOutW=%h, MemAddrW=%h, ReadDataW=%h, instrW=%h, pcplusW=%h",
                         expected_ALUOutW, expected_MemAddrW, expected_ReadDataW, expected_instrW, expected_pcplusW);
                $display("  Got:      ALUOutW=%h, MemAddrW=%h, ReadDataW=%h, instrW=%h, pcplusW=%h",
                         ALUOutW, MemAddrW, ReadDataW, instrW, pcplusW);
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
        $dumpvars(0,ALUOutM, MemAddrE, ReadDataM, clk, instrM, pcplusM, rst, ALUOutW, MemAddrW, ReadDataW, instrW, pcplusW);
    end

endmodule
