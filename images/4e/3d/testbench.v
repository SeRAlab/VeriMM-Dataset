`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Header_count;
    reg [31:0] RDAT;
    reg [31:0] dataout;
    reg [8:0] wraddr;
    wire condition_EH;
    wire condition_PL;
    wire condition_SP;
    wire condition_ST;
    wire [1:0] condition_length;
    wire [1:0] condition_length2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Header_count(Header_count),
        .RDAT(RDAT),
        .dataout(dataout),
        .wraddr(wraddr),
        .condition_EH(condition_EH),
        .condition_PL(condition_PL),
        .condition_SP(condition_SP),
        .condition_ST(condition_ST),
        .condition_length(condition_length),
        .condition_length2(condition_length2)
    );
    task testcase001;

    begin
        test_num = 1;
        Header_count = 5'h0;
        RDAT = 32'h0;
        dataout = 32'h0;
        wraddr = 9'h0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Header_count = 5'h0;
        RDAT = 32'h0;
        dataout = 32'hD0D0D0D0;
        wraddr = 9'h0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 2'b00, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Header_count = 5'd20;
        RDAT = 32'h0;
        dataout = 32'h0;
        wraddr = 9'h0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Header_count = 5'd21;
        RDAT = 32'h0;
        dataout = 32'h0;
        wraddr = 9'h0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Header_count = 5'h0;
        RDAT = 32'h0000000E;
        dataout = 32'h0;
        wraddr = 9'h0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 2'b10, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Header_count = 5'd10;
        RDAT = 32'h0;
        dataout = 32'h0;
        wraddr = 9'd11;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Header_count = 5'b11111;
        RDAT = 32'hFFFFFFFF;
        dataout = 32'hFFFFFFFF;
        wraddr = 9'h1FF;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 2'b11, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Header_count = 5'd20;
        RDAT = 32'h00000005;
        dataout = 32'hD0D0D0D0;
        wraddr = 9'd21;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b1, 2'b01, 2'b01);
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
        input expected_condition_EH;
        input expected_condition_PL;
        input expected_condition_SP;
        input expected_condition_ST;
        input [1:0] expected_condition_length;
        input [1:0] expected_condition_length2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_condition_EH === (expected_condition_EH ^ condition_EH ^ expected_condition_EH) &&
                expected_condition_PL === (expected_condition_PL ^ condition_PL ^ expected_condition_PL) &&
                expected_condition_SP === (expected_condition_SP ^ condition_SP ^ expected_condition_SP) &&
                expected_condition_ST === (expected_condition_ST ^ condition_ST ^ expected_condition_ST) &&
                expected_condition_length === (expected_condition_length ^ condition_length ^ expected_condition_length) &&
                expected_condition_length2 === (expected_condition_length2 ^ condition_length2 ^ expected_condition_length2)) begin
                $display("PASS");
                $display("  Outputs: condition_EH=%b, condition_PL=%b, condition_SP=%b, condition_ST=%b, condition_length=%h, condition_length2=%h",
                         condition_EH, condition_PL, condition_SP, condition_ST, condition_length, condition_length2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: condition_EH=%b, condition_PL=%b, condition_SP=%b, condition_ST=%b, condition_length=%h, condition_length2=%h",
                         expected_condition_EH, expected_condition_PL, expected_condition_SP, expected_condition_ST, expected_condition_length, expected_condition_length2);
                $display("  Got:      condition_EH=%b, condition_PL=%b, condition_SP=%b, condition_ST=%b, condition_length=%h, condition_length2=%h",
                         condition_EH, condition_PL, condition_SP, condition_ST, condition_length, condition_length2);
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
