`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Ein;
    reg [7:0] Input;
    wire Eout;
    wire GS;
    wire [2:0] Number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ein(Ein),
        .Input(Input),
        .Eout(Eout),
        .GS(GS),
        .Number(Number)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=0, Input=8'hFF (Module Disabled)", test_num);
        Ein = 0;
        Input = 8'hFF;
        #1;

        check_outputs(1'b0, 1'b0, 3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h00 (Enabled, Zero Input)", test_num);
        Ein = 1;
        Input = 8'h00;
        #1;

        check_outputs(1'b1, 1'b0, 3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h80 (Bit 7)", test_num);
        Ein = 1;
        Input = 8'h80;
        #1;

        check_outputs(1'b0, 1'b1, 3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h40 (Bit 6)", test_num);
        Ein = 1;
        Input = 8'h40;
        #1;

        check_outputs(1'b0, 1'b1, 3'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h20 (Bit 5)", test_num);
        Ein = 1;
        Input = 8'h20;
        #1;

        check_outputs(1'b0, 1'b1, 3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h10 (Bit 4)", test_num);
        Ein = 1;
        Input = 8'h10;
        #1;

        check_outputs(1'b0, 1'b1, 3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h08 (Bit 3)", test_num);
        Ein = 1;
        Input = 8'h08;
        #1;

        check_outputs(1'b0, 1'b1, 3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h04 (Bit 2)", test_num);
        Ein = 1;
        Input = 8'h04;
        #1;

        check_outputs(1'b0, 1'b1, 3'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h02 (Bit 1)", test_num);
        Ein = 1;
        Input = 8'h02;
        #1;

        check_outputs(1'b0, 1'b1, 3'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h01 (Bit 0)", test_num);
        Ein = 1;
        Input = 8'h01;
        #1;

        check_outputs(1'b0, 1'b1, 3'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'hAA (Bits 7, 5, 3, 1 set)", test_num);
        Ein = 1;
        Input = 8'hAA;
        #1;

        check_outputs(1'b0, 1'b1, 3'd7);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h55 (Bits 6, 4, 2, 0 set)", test_num);
        Ein = 1;
        Input = 8'h55;
        #1;

        check_outputs(1'b0, 1'b1, 3'd6);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=1, Input=8'h0F (Bits 3, 2, 1, 0 set)", test_num);
        Ein = 1;
        Input = 8'h0F;
        #1;

        check_outputs(1'b0, 1'b1, 3'd3);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Ein=0, Input=8'h00", test_num);
        Ein = 0;
        Input = 8'h00;
        #1;

        check_outputs(1'b0, 1'b0, 3'd0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input expected_Eout;
        input expected_GS;
        input [2:0] expected_Number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Eout === (expected_Eout ^ Eout ^ expected_Eout) &&
                expected_GS === (expected_GS ^ GS ^ expected_GS) &&
                expected_Number === (expected_Number ^ Number ^ expected_Number)) begin
                $display("PASS");
                $display("  Outputs: Eout=%b, GS=%b, Number=%h",
                         Eout, GS, Number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Eout=%b, GS=%b, Number=%h",
                         expected_Eout, expected_GS, expected_Number);
                $display("  Got:      Eout=%b, GS=%b, Number=%h",
                         Eout, GS, Number);
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
