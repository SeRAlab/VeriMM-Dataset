`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUDataM;
    reg MemWriteM;
    reg MemtoRegM;
    reg RegWriteM;
    reg [31:0] WriteDataM;
    reg [4:0] WriteRegM;
    reg [31:0] mem_data_i;
    wire RegWriteM_o;
    wire [4:0] WriteRegAddr;
    wire [31:0] WriteRegData;
    wire [31:0] mem_addr;
    wire [31:0] mem_wd;
    wire mem_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUDataM(ALUDataM),
        .MemWriteM(MemWriteM),
        .MemtoRegM(MemtoRegM),
        .RegWriteM(RegWriteM),
        .WriteDataM(WriteDataM),
        .WriteRegM(WriteRegM),
        .mem_data_i(mem_data_i),
        .RegWriteM_o(RegWriteM_o),
        .WriteRegAddr(WriteRegAddr),
        .WriteRegData(WriteRegData),
        .mem_addr(mem_addr),
        .mem_wd(mem_wd),
        .mem_we(mem_we)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALU Result to Register", test_num);


            RegWriteM  = 1'b1;
            MemtoRegM  = 1'b0;
            MemWriteM  = 1'b0;
            ALUDataM   = 32'hAAAA_BBBB;
            WriteDataM = 32'h0;
            WriteRegM  = 5'd10;
            mem_data_i = 32'hCCCC_DDDD;



            #1;




            check_outputs(1'b1, 5'd10, 32'hAAAA_BBBB, 32'hAAAA_BBBB, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Memory Load to Register", test_num);


            RegWriteM  = 1'b1;
            MemtoRegM  = 1'b1;
            MemWriteM  = 1'b0;
            ALUDataM   = 32'h0000_0100;
            WriteDataM = 32'h0;
            WriteRegM  = 5'd15;
            mem_data_i = 32'h1234_5678;


            #1;



            check_outputs(1'b1, 5'd15, 32'h1234_5678, 32'h0000_0100, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Memory Store", test_num);


            RegWriteM  = 1'b0;
            MemtoRegM  = 1'b0;
            MemWriteM  = 1'b1;
            ALUDataM   = 32'h0000_0200;
            WriteDataM = 32'hDEAD_BEEF;
            WriteRegM  = 5'd0;
            mem_data_i = 32'h0;


            #1;



            check_outputs(1'b0, 5'd0, 32'h0000_0200, 32'h0000_0200, 32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Register Write Disabled", test_num);


            RegWriteM  = 1'b0;
            MemtoRegM  = 1'b0;
            MemWriteM  = 1'b0;
            ALUDataM   = 32'hFFFF_FFFF;
            WriteDataM = 32'h1111_2222;
            WriteRegM  = 5'd31;
            mem_data_i = 32'h0;


            #1;



            check_outputs(1'b0, 5'd31, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'h1111_2222, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Address and Data", test_num);


            RegWriteM  = 1'b1;
            MemtoRegM  = 1'b0;
            MemWriteM  = 1'b0;
            ALUDataM   = 32'h7FFF_FFFF;
            WriteDataM = 32'hFFFF_0000;
            WriteRegM  = 5'd31;
            mem_data_i = 32'h0;


            #1;



            check_outputs(1'b1, 5'd31, 32'h7FFF_FFFF, 32'h7FFF_FFFF, 32'hFFFF_0000, 1'b0);
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
        input expected_RegWriteM_o;
        input [4:0] expected_WriteRegAddr;
        input [31:0] expected_WriteRegData;
        input [31:0] expected_mem_addr;
        input [31:0] expected_mem_wd;
        input expected_mem_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RegWriteM_o === (expected_RegWriteM_o ^ RegWriteM_o ^ expected_RegWriteM_o) &&
                expected_WriteRegAddr === (expected_WriteRegAddr ^ WriteRegAddr ^ expected_WriteRegAddr) &&
                expected_WriteRegData === (expected_WriteRegData ^ WriteRegData ^ expected_WriteRegData) &&
                expected_mem_addr === (expected_mem_addr ^ mem_addr ^ expected_mem_addr) &&
                expected_mem_wd === (expected_mem_wd ^ mem_wd ^ expected_mem_wd) &&
                expected_mem_we === (expected_mem_we ^ mem_we ^ expected_mem_we)) begin
                $display("PASS");
                $display("  Outputs: RegWriteM_o=%b, WriteRegAddr=%h, WriteRegData=%h, mem_addr=%h, mem_wd=%h, mem_we=%b",
                         RegWriteM_o, WriteRegAddr, WriteRegData, mem_addr, mem_wd, mem_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegWriteM_o=%b, WriteRegAddr=%h, WriteRegData=%h, mem_addr=%h, mem_wd=%h, mem_we=%b",
                         expected_RegWriteM_o, expected_WriteRegAddr, expected_WriteRegData, expected_mem_addr, expected_mem_wd, expected_mem_we);
                $display("  Got:      RegWriteM_o=%b, WriteRegAddr=%h, WriteRegData=%h, mem_addr=%h, mem_wd=%h, mem_we=%b",
                         RegWriteM_o, WriteRegAddr, WriteRegData, mem_addr, mem_wd, mem_we);
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

endmodule
