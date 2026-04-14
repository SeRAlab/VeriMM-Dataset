`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iAZERO;
    reg [31:0] iINST;
    wire [7:0] oIMMBV;
    wire oPCJEN;
    wire [2:0] oSAOUT;
    wire [1:0] oSGPRI;
    wire [3:0] oSREGA;
    wire [3:0] oSREGB;
    wire [3:0] oSSFRR;
    wire oUAZRO;
    wire oUIMMB;
    wire oWRDTA;
    wire oWRGPR;
    wire oWRMLR;
    wire oWRSFR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iAZERO(iAZERO),
        .iINST(iINST),
        .oIMMBV(oIMMBV),
        .oPCJEN(oPCJEN),
        .oSAOUT(oSAOUT),
        .oSGPRI(oSGPRI),
        .oSREGA(oSREGA),
        .oSREGB(oSREGB),
        .oSSFRR(oSSFRR),
        .oUAZRO(oUAZRO),
        .oUIMMB(oUIMMB),
        .oWRDTA(oWRDTA),
        .oWRGPR(oWRGPR),
        .oWRMLR(oWRMLR),
        .oWRSFR(oWRSFR)
    );
    task testcase001;

    begin
        test_num = 1;
        iINST = 32'h00000000;
        iAZERO = 0;

        #1;


        check_outputs(8'h00, 1'b0, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        iINST = 32'hF0000000;
        iAZERO = 0;
        #1;

        check_outputs(8'h00, 1'b0, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        iINST = 32'h000000A5;
        iAZERO = 0;
        #1;

        check_outputs(8'hA5, 1'b0, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        iINST = 32'h000F5A00;
        iAZERO = 0;
        #1;

        check_outputs(8'h00, 1'b0, 3'b000, 2'b00, 4'hF, 4'h5, 4'hA, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        iINST = 32'h07800000;
        iAZERO = 0;
        #1;

        check_outputs(8'h00, 1'b0, 3'b111, 2'b01, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        iINST = 32'h00100000;
        iAZERO = 0;
        #1;

        check_outputs(8'h00, 1'b1, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        iINST = 32'h00500000;
        iAZERO = 1;
        #1;

        check_outputs(8'h00, 1'b1, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        iINST = 32'h00500000;
        iAZERO = 0;
        #1;

        check_outputs(8'h00, 1'b0, 3'b000, 2'b00, 4'h0, 4'h0, 4'h0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_oIMMBV;
        input expected_oPCJEN;
        input [2:0] expected_oSAOUT;
        input [1:0] expected_oSGPRI;
        input [3:0] expected_oSREGA;
        input [3:0] expected_oSREGB;
        input [3:0] expected_oSSFRR;
        input expected_oUAZRO;
        input expected_oUIMMB;
        input expected_oWRDTA;
        input expected_oWRGPR;
        input expected_oWRMLR;
        input expected_oWRSFR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oIMMBV === (expected_oIMMBV ^ oIMMBV ^ expected_oIMMBV) &&
                expected_oPCJEN === (expected_oPCJEN ^ oPCJEN ^ expected_oPCJEN) &&
                expected_oSAOUT === (expected_oSAOUT ^ oSAOUT ^ expected_oSAOUT) &&
                expected_oSGPRI === (expected_oSGPRI ^ oSGPRI ^ expected_oSGPRI) &&
                expected_oSREGA === (expected_oSREGA ^ oSREGA ^ expected_oSREGA) &&
                expected_oSREGB === (expected_oSREGB ^ oSREGB ^ expected_oSREGB) &&
                expected_oSSFRR === (expected_oSSFRR ^ oSSFRR ^ expected_oSSFRR) &&
                expected_oUAZRO === (expected_oUAZRO ^ oUAZRO ^ expected_oUAZRO) &&
                expected_oUIMMB === (expected_oUIMMB ^ oUIMMB ^ expected_oUIMMB) &&
                expected_oWRDTA === (expected_oWRDTA ^ oWRDTA ^ expected_oWRDTA) &&
                expected_oWRGPR === (expected_oWRGPR ^ oWRGPR ^ expected_oWRGPR) &&
                expected_oWRMLR === (expected_oWRMLR ^ oWRMLR ^ expected_oWRMLR) &&
                expected_oWRSFR === (expected_oWRSFR ^ oWRSFR ^ expected_oWRSFR)) begin
                $display("PASS");
                $display("  Outputs: oIMMBV=%h, oPCJEN=%b, oSAOUT=%h, oSGPRI=%h, oSREGA=%h, oSREGB=%h, oSSFRR=%h, oUAZRO=%b, oUIMMB=%b, oWRDTA=%b, oWRGPR=%b, oWRMLR=%b, oWRSFR=%b",
                         oIMMBV, oPCJEN, oSAOUT, oSGPRI, oSREGA, oSREGB, oSSFRR, oUAZRO, oUIMMB, oWRDTA, oWRGPR, oWRMLR, oWRSFR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oIMMBV=%h, oPCJEN=%b, oSAOUT=%h, oSGPRI=%h, oSREGA=%h, oSREGB=%h, oSSFRR=%h, oUAZRO=%b, oUIMMB=%b, oWRDTA=%b, oWRGPR=%b, oWRMLR=%b, oWRSFR=%b",
                         expected_oIMMBV, expected_oPCJEN, expected_oSAOUT, expected_oSGPRI, expected_oSREGA, expected_oSREGB, expected_oSSFRR, expected_oUAZRO, expected_oUIMMB, expected_oWRDTA, expected_oWRGPR, expected_oWRMLR, expected_oWRSFR);
                $display("  Got:      oIMMBV=%h, oPCJEN=%b, oSAOUT=%h, oSGPRI=%h, oSREGA=%h, oSREGB=%h, oSSFRR=%h, oUAZRO=%b, oUIMMB=%b, oWRDTA=%b, oWRGPR=%b, oWRMLR=%b, oWRSFR=%b",
                         oIMMBV, oPCJEN, oSAOUT, oSGPRI, oSREGA, oSREGB, oSSFRR, oUAZRO, oUIMMB, oWRDTA, oWRGPR, oWRMLR, oWRSFR);
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
