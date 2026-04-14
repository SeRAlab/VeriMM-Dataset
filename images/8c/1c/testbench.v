`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A3_SEL;
    reg ALUB_SEL;
    reg AO_SEL_E;
    reg [31:0] HL_E;
    reg [31:0] IR_D;
    reg [31:0] PC8_W;
    reg [31:0] RDATA;
    reg [31:0] RES_ALU_E;
    reg [31:0] RES_ALU_W;
    reg [31:0] RF_RT;
    reg [1:0] WD3_SEL;
    reg [31:0] imm_ext;
    wire [4:0] A3;
    wire [31:0] ALUB;
    wire [31:0] AO_E;
    wire [31:0] WD3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A3_SEL(A3_SEL),
        .ALUB_SEL(ALUB_SEL),
        .AO_SEL_E(AO_SEL_E),
        .HL_E(HL_E),
        .IR_D(IR_D),
        .PC8_W(PC8_W),
        .RDATA(RDATA),
        .RES_ALU_E(RES_ALU_E),
        .RES_ALU_W(RES_ALU_W),
        .RF_RT(RF_RT),
        .WD3_SEL(WD3_SEL),
        .imm_ext(imm_ext),
        .A3(A3),
        .ALUB(ALUB),
        .AO_E(AO_E),
        .WD3(WD3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A3_SEL=0 (rt), ALUB_SEL=0 (RF), WD3_SEL=0 (ALU_W), AO_SEL_E=0 (ALU_E)", test_num);


            IR_D = 32'h02B25820;
            A3_SEL = 2'b00;
            RF_RT = 32'hAAAA_AAAA;
            imm_ext = 32'hBBBB_BBBB;
            ALUB_SEL = 1'b0;
            RDATA = 32'hDDDD_DDDD;
            RES_ALU_W = 32'hCCCC_CCCC;
            PC8_W = 32'hEEEE_EEEE;
            WD3_SEL = 2'b00;
            RES_ALU_E = 32'h1111_1111;
            HL_E = 32'h2222_2222;
            AO_SEL_E = 1'b0;


            #1;



            check_outputs(5'h12, 32'hAAAA_AAAA, 32'h1111_1111, 32'hCCCC_CCCC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A3_SEL=1 (rd), ALUB_SEL=1 (imm), WD3_SEL=1 (RDATA), AO_SEL_E=1 (HL_E)", test_num);


            IR_D = 32'h02B25820;
            A3_SEL = 2'b01;
            RF_RT = 32'hAAAA_AAAA;
            imm_ext = 32'hBBBB_BBBB;
            ALUB_SEL = 1'b1;
            RDATA = 32'hDDDD_DDDD;
            RES_ALU_W = 32'hCCCC_CCCC;
            PC8_W = 32'hEEEE_EEEE;
            WD3_SEL = 2'b01;
            RES_ALU_E = 32'h1111_1111;
            HL_E = 32'h2222_2222;
            AO_SEL_E = 1'b1;


            #1;



            check_outputs(5'h0B, 32'hBBBB_BBBB, 32'h2222_2222, 32'hDDDD_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A3_SEL=2 ($ra), WD3_SEL=2 (PC8_W)", test_num);


            IR_D = 32'h0000_0000;
            A3_SEL = 2'b10;
            RF_RT = 32'h1234_5678;
            imm_ext = 32'h0000_0000;
            ALUB_SEL = 1'b0;
            RDATA = 32'h0000_0000;
            RES_ALU_W = 32'h0000_0000;
            PC8_W = 32'h0040_0008;
            WD3_SEL = 2'b10;
            RES_ALU_E = 32'h9999_9999;
            HL_E = 32'h8888_8888;
            AO_SEL_E = 1'b0;


            #1;



            check_outputs(5'd31, 32'h1234_5678, 32'h9999_9999, 32'h0040_0008);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs and default selection check", test_num);


            IR_D = 32'h0000_0000;
            A3_SEL = 2'b11;
            RF_RT = 32'h0;
            imm_ext = 32'h0;
            ALUB_SEL = 1'b0;
            RDATA = 32'h0;
            RES_ALU_W = 32'h0;
            PC8_W = 32'h0;
            WD3_SEL = 2'b11;
            RES_ALU_E = 32'h0;
            HL_E = 32'h0;
            AO_SEL_E = 1'b0;


            #1;



            check_outputs(5'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternate bit patterns", test_num);


            IR_D = 32'hFFFF_FFFF;
            A3_SEL = 2'b01;
            RF_RT = 32'h5555_5555;
            imm_ext = 32'hAAAA_AAAA;
            ALUB_SEL = 1'b1;
            RDATA = 32'h3333_3333;
            RES_ALU_W = 32'hCCCC_CCCC;
            PC8_W = 32'hF0F0_F0F0;
            WD3_SEL = 2'b01;
            RES_ALU_E = 32'h0F0F_0F0F;
            HL_E = 32'h7777_7777;
            AO_SEL_E = 1'b1;


            #1;



            check_outputs(5'h1F, 32'hAAAA_AAAA, 32'h7777_7777, 32'h3333_3333);
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
        input [4:0] expected_A3;
        input [31:0] expected_ALUB;
        input [31:0] expected_AO_E;
        input [31:0] expected_WD3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A3 === (expected_A3 ^ A3 ^ expected_A3) &&
                expected_ALUB === (expected_ALUB ^ ALUB ^ expected_ALUB) &&
                expected_AO_E === (expected_AO_E ^ AO_E ^ expected_AO_E) &&
                expected_WD3 === (expected_WD3 ^ WD3 ^ expected_WD3)) begin
                $display("PASS");
                $display("  Outputs: A3=%h, ALUB=%h, AO_E=%h, WD3=%h",
                         A3, ALUB, AO_E, WD3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A3=%h, ALUB=%h, AO_E=%h, WD3=%h",
                         expected_A3, expected_ALUB, expected_AO_E, expected_WD3);
                $display("  Got:      A3=%h, ALUB=%h, AO_E=%h, WD3=%h",
                         A3, ALUB, AO_E, WD3);
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
