`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUOutE;
    reg MemWriteE;
    reg MemtoRegE;
    reg RegWriteE;
    reg Reset;
    reg [31:0] WriteDataE;
    reg [31:0] WriteRegE;
    reg clk;
    wire [31:0] ALUOutM;
    wire MemWriteM;
    wire MemtoRegM;
    wire RegWriteM;
    wire [31:0] WriteDataM;
    wire [31:0] WriteRegM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutE(ALUOutE),
        .MemWriteE(MemWriteE),
        .MemtoRegE(MemtoRegE),
        .RegWriteE(RegWriteE),
        .Reset(Reset),
        .WriteDataE(WriteDataE),
        .WriteRegE(WriteRegE),
        .clk(clk),
        .ALUOutM(ALUOutM),
        .MemWriteM(MemWriteM),
        .MemtoRegM(MemtoRegM),
        .RegWriteM(RegWriteM),
        .WriteDataM(WriteDataM),
        .WriteRegM(WriteRegM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            ALUOutE = 0;
            MemWriteE = 0;
            MemtoRegE = 0;
            RegWriteE = 0;
            WriteDataE = 0;
            WriteRegE = 0;
            @(posedge clk);
            #1;
            Reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 0, 0, 0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Store Word Signal Forwarding", test_num);
            reset_dut();


            ALUOutE    = 32'h0000_1000;
            WriteDataE = 32'hAAAA_BBBB;
            WriteRegE  = 32'h0000_000F;
            MemWriteE  = 1;
            MemtoRegE  = 0;
            RegWriteE  = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_1000, 1, 0, 0, 32'hAAAA_BBBB, 32'h0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: ALU Operation Signal Forwarding", test_num);
            reset_dut();

            ALUOutE    = 32'h1234_5678;
            WriteDataE = 32'h0;
            WriteRegE  = 32'h0000_001F;
            MemWriteE  = 0;
            MemtoRegE  = 0;
            RegWriteE  = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1234_5678, 0, 0, 1, 32'h0, 32'h0000_001F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load Word Signal Forwarding", test_num);
            reset_dut();

            ALUOutE    = 32'hFFFF_0000;
            WriteDataE = 32'h0;
            WriteRegE  = 32'h0000_0005;
            MemWriteE  = 0;
            MemtoRegE  = 1;
            RegWriteE  = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_0000, 0, 1, 1, 32'h0, 32'h0000_0005);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Back-to-back Update Check", test_num);
            reset_dut();


            ALUOutE    = 32'hA1A1_A1A1;
            WriteDataE = 32'hB1B1_B1B1;
            WriteRegE  = 32'h1;
            MemWriteE  = 1;
            MemtoRegE  = 1;
            RegWriteE  = 1;
            @(posedge clk);
            #1;


            ALUOutE    = 32'hA2A2_A2A2;
            WriteDataE = 32'hB2B2_B2B2;
            WriteRegE  = 32'h2;
            MemWriteE  = 0;
            MemtoRegE  = 0;
            RegWriteE  = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hA2A2_A2A2, 0, 0, 0, 32'hB2B2_B2B2, 32'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 32-bit Integrity Check", test_num);
            reset_dut();

            ALUOutE    = 32'h5555_AAAA;
            WriteDataE = 32'hAAAA_5555;
            WriteRegE  = 32'hFFFF_FFFF;
            MemWriteE  = 1;
            MemtoRegE  = 1;
            RegWriteE  = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555_AAAA, 1, 1, 1, 32'hAAAA_5555, 32'hFFFF_FFFF);
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
        input [31:0] expected_ALUOutM;
        input expected_MemWriteM;
        input expected_MemtoRegM;
        input expected_RegWriteM;
        input [31:0] expected_WriteDataM;
        input [31:0] expected_WriteRegM;
        begin
            if (expected_ALUOutM === (expected_ALUOutM ^ ALUOutM ^ expected_ALUOutM) &&
                expected_MemWriteM === (expected_MemWriteM ^ MemWriteM ^ expected_MemWriteM) &&
                expected_MemtoRegM === (expected_MemtoRegM ^ MemtoRegM ^ expected_MemtoRegM) &&
                expected_RegWriteM === (expected_RegWriteM ^ RegWriteM ^ expected_RegWriteM) &&
                expected_WriteDataM === (expected_WriteDataM ^ WriteDataM ^ expected_WriteDataM) &&
                expected_WriteRegM === (expected_WriteRegM ^ WriteRegM ^ expected_WriteRegM)) begin
                $display("PASS");
                $display("  Outputs: ALUOutM=%h, MemWriteM=%b, MemtoRegM=%b, RegWriteM=%b, WriteDataM=%h, WriteRegM=%h",
                         ALUOutM, MemWriteM, MemtoRegM, RegWriteM, WriteDataM, WriteRegM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUOutM=%h, MemWriteM=%b, MemtoRegM=%b, RegWriteM=%b, WriteDataM=%h, WriteRegM=%h",
                         expected_ALUOutM, expected_MemWriteM, expected_MemtoRegM, expected_RegWriteM, expected_WriteDataM, expected_WriteRegM);
                $display("  Got:      ALUOutM=%h, MemWriteM=%b, MemtoRegM=%b, RegWriteM=%b, WriteDataM=%h, WriteRegM=%h",
                         ALUOutM, MemWriteM, MemtoRegM, RegWriteM, WriteDataM, WriteRegM);
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
        $dumpvars(0,ALUOutE, MemWriteE, MemtoRegE, RegWriteE, Reset, WriteDataE, WriteRegE, clk, ALUOutM, MemWriteM, MemtoRegM, RegWriteM, WriteDataM, WriteRegM);
    end

endmodule
