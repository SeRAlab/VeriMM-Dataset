`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg isDiv;
    reg isMult;
    reg isSigned;
    reg [31:0] rs1;
    reg [31:0] rs2;
    wire [31:0] hi_o;
    wire [31:0] lo_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .isDiv(isDiv),
        .isMult(isMult),
        .isSigned(isSigned),
        .rs1(rs1),
        .rs2(rs2),
        .hi_o(hi_o),
        .lo_o(lo_o)
    );
    task testcase001;

    begin
        test_num = 1;
        rs1 = 32'd12;
        rs2 = 32'd12;
        isMult = 1'b1;
        isDiv = 1'b0;
        isSigned = 1'b0;
        #1;

        check_outputs(32'h00000000, 32'd144);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rs1 = 32'hFFFFFFFF;
        rs2 = 32'd2;
        isMult = 1'b1;
        isDiv = 1'b0;
        isSigned = 1'b0;
        #1;

        check_outputs(32'h00000001, 32'hFFFFFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rs1 = 32'd10;
        rs2 = 32'hFFFFFFFB;
        isMult = 1'b1;
        isDiv = 1'b0;
        isSigned = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF, 32'hFFFFFFCE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rs1 = 32'hFFFFFFF6;
        rs2 = 32'hFFFFFFF6;
        isMult = 1'b1;
        isDiv = 1'b0;
        isSigned = 1'b1;
        #1;

        check_outputs(32'h00000000, 32'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rs1 = 32'd100;
        rs2 = 32'd7;
        isMult = 1'b0;
        isDiv = 1'b1;
        isSigned = 1'b0;
        #1;

        check_outputs(32'h00000002, 32'h0000000E);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rs1 = 32'hFFFFFFFF9C;

        rs1 = 32'hFFFFFFFF ^ 32'd99;
        rs2 = 32'd7;
        isMult = 1'b0;
        isDiv = 1'b1;
        isSigned = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFE, 32'hFFFFFFF2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rs1 = 32'd100;
        rs2 = 32'hFFFFFFF9;
        isMult = 1'b0;
        isDiv = 1'b1;
        isSigned = 1'b1;
        #1;

        check_outputs(32'h00000002, 32'hFFFFFFF2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rs1 = 32'hFFFFFFA4;
        rs1 = 32'hFFFFFFFF - 32'd99;
        rs2 = 32'hFFFFFFF9;
        isMult = 1'b0;
        isDiv = 1'b1;
        isSigned = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFE, 32'h0000000E);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        rs1 = 32'd5;
        rs2 = 32'd10;
        isMult = 1'b0;
        isDiv = 1'b1;
        isSigned = 1'b0;
        #1;

        check_outputs(32'h00000005, 32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        rs1 = 32'h80000000;
        rs2 = 32'd2;
        isMult = 1'b1;
        isDiv = 1'b0;
        isSigned = 1'b1;
        #1;

        check_outputs(32'hFFFFFFFF, 32'h00000000);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_hi_o;
        input [31:0] expected_lo_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hi_o === (expected_hi_o ^ hi_o ^ expected_hi_o) &&
                expected_lo_o === (expected_lo_o ^ lo_o ^ expected_lo_o)) begin
                $display("PASS");
                $display("  Outputs: hi_o=%h, lo_o=%h",
                         hi_o, lo_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi_o=%h, lo_o=%h",
                         expected_hi_o, expected_lo_o);
                $display("  Got:      hi_o=%h, lo_o=%h",
                         hi_o, lo_o);
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
