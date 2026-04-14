`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] InstrIn;
    reg clk;
    reg reset;
    wire [2:0] ALUop;
    wire Datasource;
    wire [15:0] S1_Imm;
    wire [31:0] S1_ReadSelect1;
    wire [31:0] S1_ReadSelect2;
    wire S1_WriteEnable;
    wire [4:0] S1_WriteSelect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InstrIn(InstrIn),
        .clk(clk),
        .reset(reset),
        .ALUop(ALUop),
        .Datasource(Datasource),
        .S1_Imm(S1_Imm),
        .S1_ReadSelect1(S1_ReadSelect1),
        .S1_ReadSelect2(S1_ReadSelect2),
        .S1_WriteEnable(S1_WriteEnable),
        .S1_WriteSelect(S1_WriteSelect)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            InstrIn = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(3'h0, 1'b0, 16'h0000, 32'h0, 32'h0, 1'b0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Bit Field Extraction", test_num);
            reset_dut();
            InstrIn = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'h7, 1'b1, 16'hFFFF, 32'h1F, 32'h1F, 1'b1, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: R-Type Style Extraction", test_num);
            reset_dut();


            InstrIn = 32'b000000_01010_00101_00011_00000_010010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'h2, 1'b0, 16'h1812, 32'h0A, 32'h05, 1'b1, 5'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: I-Type Style Extraction", test_num);
            reset_dut();


            InstrIn = 32'h0255ABCD;
            @(posedge clk);
            #2;

            #1;


            check_outputs(3'h5, 1'b1, 16'hABCD, 32'h12, 32'h15, 1'b0, 5'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern", test_num);
            reset_dut();
            InstrIn = 32'hAAAA_AAAA;
            @(posedge clk);
            #2;


            #1;



            check_outputs(3'h2, 1'b1, 16'hAAAA, 32'h15, 32'h0A, 1'b0, 5'h15);
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
        input [2:0] expected_ALUop;
        input expected_Datasource;
        input [15:0] expected_S1_Imm;
        input [31:0] expected_S1_ReadSelect1;
        input [31:0] expected_S1_ReadSelect2;
        input expected_S1_WriteEnable;
        input [4:0] expected_S1_WriteSelect;
        begin
            if (expected_ALUop === (expected_ALUop ^ ALUop ^ expected_ALUop) &&
                expected_Datasource === (expected_Datasource ^ Datasource ^ expected_Datasource) &&
                expected_S1_Imm === (expected_S1_Imm ^ S1_Imm ^ expected_S1_Imm) &&
                expected_S1_ReadSelect1 === (expected_S1_ReadSelect1 ^ S1_ReadSelect1 ^ expected_S1_ReadSelect1) &&
                expected_S1_ReadSelect2 === (expected_S1_ReadSelect2 ^ S1_ReadSelect2 ^ expected_S1_ReadSelect2) &&
                expected_S1_WriteEnable === (expected_S1_WriteEnable ^ S1_WriteEnable ^ expected_S1_WriteEnable) &&
                expected_S1_WriteSelect === (expected_S1_WriteSelect ^ S1_WriteSelect ^ expected_S1_WriteSelect)) begin
                $display("PASS");
                $display("  Outputs: ALUop=%h, Datasource=%b, S1_Imm=%h, S1_ReadSelect1=%h, S1_ReadSelect2=%h, S1_WriteEnable=%b, S1_WriteSelect=%h",
                         ALUop, Datasource, S1_Imm, S1_ReadSelect1, S1_ReadSelect2, S1_WriteEnable, S1_WriteSelect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUop=%h, Datasource=%b, S1_Imm=%h, S1_ReadSelect1=%h, S1_ReadSelect2=%h, S1_WriteEnable=%b, S1_WriteSelect=%h",
                         expected_ALUop, expected_Datasource, expected_S1_Imm, expected_S1_ReadSelect1, expected_S1_ReadSelect2, expected_S1_WriteEnable, expected_S1_WriteSelect);
                $display("  Got:      ALUop=%h, Datasource=%b, S1_Imm=%h, S1_ReadSelect1=%h, S1_ReadSelect2=%h, S1_WriteEnable=%b, S1_WriteSelect=%h",
                         ALUop, Datasource, S1_Imm, S1_ReadSelect1, S1_ReadSelect2, S1_WriteEnable, S1_WriteSelect);
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
        $dumpvars(0,InstrIn, clk, reset, ALUop, Datasource, S1_Imm, S1_ReadSelect1, S1_ReadSelect2, S1_WriteEnable, S1_WriteSelect);
    end

endmodule
