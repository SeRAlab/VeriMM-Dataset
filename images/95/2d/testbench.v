`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] EXMEM_ALUresult;
    reg [63:0] EXMEM_MEMout;
    reg [4:0] EXMEM_Wreg;
    reg EXMEM_Wreg_en;
    reg [5:0] EXMEM_instr_type;
    reg [5:0] EXMEM_opcode;
    reg [2:0] EXMEM_ppp;
    reg clk;
    reg rst;
    wire [63:0] WB_ALUresult;
    wire [63:0] WB_MEMout;
    wire [4:0] WB_Wreg;
    wire WB_Wreg_en;
    wire [5:0] WB_instr_type;
    wire [5:0] WB_opcode;
    wire [2:0] WB_ppp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEM_ALUresult(EXMEM_ALUresult),
        .EXMEM_MEMout(EXMEM_MEMout),
        .EXMEM_Wreg(EXMEM_Wreg),
        .EXMEM_Wreg_en(EXMEM_Wreg_en),
        .EXMEM_instr_type(EXMEM_instr_type),
        .EXMEM_opcode(EXMEM_opcode),
        .EXMEM_ppp(EXMEM_ppp),
        .clk(clk),
        .rst(rst),
        .WB_ALUresult(WB_ALUresult),
        .WB_MEMout(WB_MEMout),
        .WB_Wreg(WB_Wreg),
        .WB_Wreg_en(WB_Wreg_en),
        .WB_instr_type(WB_instr_type),
        .WB_opcode(WB_opcode),
        .WB_ppp(WB_ppp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            EXMEM_ALUresult = 0;
            EXMEM_MEMout = 0;
            EXMEM_Wreg = 0;
            EXMEM_Wreg_en = 0;
            EXMEM_instr_type = 0;
            EXMEM_opcode = 0;
            EXMEM_ppp = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Verification", test_num);


            EXMEM_ALUresult = 64'hFFFFFFFFFFFFFFFF;
            EXMEM_MEMout = 64'hFFFFFFFFFFFFFFFF;
            EXMEM_Wreg = 5'h1F;
            EXMEM_Wreg_en = 1'b1;
            EXMEM_instr_type = 6'h3F;
            EXMEM_opcode = 6'h3F;
            EXMEM_ppp = 3'h7;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(64'h0, 64'h0, 5'h0, 1'b0, 6'h0, 6'h0, 3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Data Propagation", test_num);
            reset_dut();

            EXMEM_ALUresult = 64'hABCDEF0123456789;
            EXMEM_MEMout    = 64'h9876543210FEDCBA;
            EXMEM_Wreg      = 5'd15;
            EXMEM_Wreg_en   = 1'b1;
            EXMEM_instr_type = 6'd20;
            EXMEM_opcode    = 6'd10;
            EXMEM_ppp       = 3'd3;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hABCDEF0123456789, 64'h9876543210FEDCBA, 5'd15, 1'b1, 6'd20, 6'd10, 3'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Control Signal Toggling", test_num);
            reset_dut();

            EXMEM_ALUresult = 64'h5555555555555555;
            EXMEM_MEMout    = 64'hAAAAAAAAAAAAAAAA;
            EXMEM_Wreg      = 5'd31;
            EXMEM_Wreg_en   = 1'b0;
            EXMEM_instr_type = 6'd1;
            EXMEM_opcode    = 6'd63;
            EXMEM_ppp       = 3'd7;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA, 5'd31, 1'b0, 6'd1, 6'd63, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Successive Updates", test_num);
            reset_dut();


            EXMEM_ALUresult = 64'h1;
            EXMEM_MEMout    = 64'h2;
            EXMEM_Wreg      = 5'h1;
            EXMEM_Wreg_en   = 1'b1;
            EXMEM_instr_type = 6'h1;
            EXMEM_opcode    = 6'h1;
            EXMEM_ppp       = 3'h1;
            @(posedge clk);


            EXMEM_ALUresult = 64'hDEADBEEF;
            EXMEM_MEMout    = 64'hCAFEBABE;
            EXMEM_Wreg      = 5'hA;
            EXMEM_Wreg_en   = 1'b1;
            EXMEM_instr_type = 6'hA;
            EXMEM_opcode    = 6'hA;
            EXMEM_ppp       = 3'h2;

            @(posedge clk);
            #2;


            #1;



            check_outputs(64'hDEADBEEF, 64'hCAFEBABE, 5'hA, 1'b1, 6'hA, 6'hA, 3'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Values", test_num);
            reset_dut();


            EXMEM_ALUresult = {64{1'b1}};
            EXMEM_MEMout    = {64{1'b1}};
            EXMEM_Wreg      = 5'h1F;
            EXMEM_Wreg_en   = 1'b1;
            EXMEM_instr_type = 6'h3F;
            EXMEM_opcode    = 6'h3F;
            EXMEM_ppp       = 3'h7;

            @(posedge clk);
            #2;
            #1;

            check_outputs({64{1'b1}}, {64{1'b1}}, 5'h1F, 1'b1, 6'h3F, 6'h3F, 3'h7);
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
        input [63:0] expected_WB_ALUresult;
        input [63:0] expected_WB_MEMout;
        input [4:0] expected_WB_Wreg;
        input expected_WB_Wreg_en;
        input [5:0] expected_WB_instr_type;
        input [5:0] expected_WB_opcode;
        input [2:0] expected_WB_ppp;
        begin
            if (expected_WB_ALUresult === (expected_WB_ALUresult ^ WB_ALUresult ^ expected_WB_ALUresult) &&
                expected_WB_MEMout === (expected_WB_MEMout ^ WB_MEMout ^ expected_WB_MEMout) &&
                expected_WB_Wreg === (expected_WB_Wreg ^ WB_Wreg ^ expected_WB_Wreg) &&
                expected_WB_Wreg_en === (expected_WB_Wreg_en ^ WB_Wreg_en ^ expected_WB_Wreg_en) &&
                expected_WB_instr_type === (expected_WB_instr_type ^ WB_instr_type ^ expected_WB_instr_type) &&
                expected_WB_opcode === (expected_WB_opcode ^ WB_opcode ^ expected_WB_opcode) &&
                expected_WB_ppp === (expected_WB_ppp ^ WB_ppp ^ expected_WB_ppp)) begin
                $display("PASS");
                $display("  Outputs: WB_ALUresult=%h, WB_MEMout=%h, WB_Wreg=%h, WB_Wreg_en=%b, WB_instr_type=%h, WB_opcode=%h, WB_ppp=%h",
                         WB_ALUresult, WB_MEMout, WB_Wreg, WB_Wreg_en, WB_instr_type, WB_opcode, WB_ppp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_ALUresult=%h, WB_MEMout=%h, WB_Wreg=%h, WB_Wreg_en=%b, WB_instr_type=%h, WB_opcode=%h, WB_ppp=%h",
                         expected_WB_ALUresult, expected_WB_MEMout, expected_WB_Wreg, expected_WB_Wreg_en, expected_WB_instr_type, expected_WB_opcode, expected_WB_ppp);
                $display("  Got:      WB_ALUresult=%h, WB_MEMout=%h, WB_Wreg=%h, WB_Wreg_en=%b, WB_instr_type=%h, WB_opcode=%h, WB_ppp=%h",
                         WB_ALUresult, WB_MEMout, WB_Wreg, WB_Wreg_en, WB_instr_type, WB_opcode, WB_ppp);
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
        $dumpvars(0,EXMEM_ALUresult, EXMEM_MEMout, EXMEM_Wreg, EXMEM_Wreg_en, EXMEM_instr_type, EXMEM_opcode, EXMEM_ppp, clk, rst, WB_ALUresult, WB_MEMout, WB_Wreg, WB_Wreg_en, WB_instr_type, WB_opcode, WB_ppp);
    end

endmodule
