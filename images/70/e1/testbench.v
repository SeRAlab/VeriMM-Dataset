`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IDATA1;
    reg [31:0] IDATA2;
    reg [31:0] IDATA3;
    reg [31:0] IDATA4;
    reg [31:0] IDATA5;
    reg [31:0] IDATA6;
    reg [2:0] SELECT;
    wire [31:0] ODATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IDATA1(IDATA1),
        .IDATA2(IDATA2),
        .IDATA3(IDATA3),
        .IDATA4(IDATA4),
        .IDATA5(IDATA5),
        .IDATA6(IDATA6),
        .SELECT(SELECT),
        .ODATA(ODATA)
    );
    task testcase001;

    begin
        test_num = 1;
        IDATA1 = 32'hAAAAAAAA;
        IDATA2 = 32'hBBBBBBBB;
        IDATA3 = 32'hCCCCCCCC;
        IDATA4 = 32'hDDDDDDDD;
        IDATA5 = 32'hEEEEEEEE;
        IDATA6 = 32'hFFFFFFFF;
        SELECT = 3'b000;
        $display("Running Testcase %03d: SELECT = 000 (Expecting IDATA1)", test_num);
        #1;

        check_outputs(IDATA1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        IDATA1 = 32'h11111111;
        IDATA2 = 32'h22222222;
        IDATA3 = 32'h33333333;
        IDATA4 = 32'h44444444;
        IDATA5 = 32'h55555555;
        IDATA6 = 32'h66666666;
        SELECT = 3'b001;
        $display("Running Testcase %03d: SELECT = 001 (Expecting IDATA2)", test_num);
        #1;

        check_outputs(IDATA2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        SELECT = 3'b010;
        $display("Running Testcase %03d: SELECT = 010 (Expecting IDATA3)", test_num);
        #1;

        check_outputs(IDATA3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        SELECT = 3'b011;
        $display("Running Testcase %03d: SELECT = 011 (Expecting IDATA4)", test_num);
        #1;

        check_outputs(IDATA4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        SELECT = 3'b100;
        $display("Running Testcase %03d: SELECT = 100 (Expecting IDATA5)", test_num);
        #1;

        check_outputs(IDATA5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        SELECT = 3'b101;
        $display("Running Testcase %03d: SELECT = 101 (Expecting IDATA6)", test_num);
        #1;

        check_outputs(IDATA6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        IDATA1 = 32'hDEADBEEF;
        SELECT = 3'b110;
        $display("Running Testcase %03d: SELECT = 110 (Expecting IDATA1 - Default)", test_num);
        #1;

        check_outputs(IDATA1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        IDATA1 = 32'hCAFEBABE;
        SELECT = 3'b111;
        $display("Running Testcase %03d: SELECT = 111 (Expecting IDATA1 - Default)", test_num);
        #1;

        check_outputs(IDATA1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        SELECT = 3'b010;
        IDATA3 = 32'h87654321;
        $display("Running Testcase %03d: Dynamic Data Change on SELECT 010", test_num);
        #1;

        check_outputs(32'h87654321);
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
        input [31:0] expected_ODATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ODATA === (expected_ODATA ^ ODATA ^ expected_ODATA)) begin
                $display("PASS");
                $display("  Outputs: ODATA=%h",
                         ODATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ODATA=%h",
                         expected_ODATA);
                $display("  Got:      ODATA=%h",
                         ODATA);
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
