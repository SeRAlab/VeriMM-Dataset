`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg ADDSUB;
    reg [7:0] B;
    wire [7:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .ADDSUB(ADDSUB),
        .B(B),
        .RES(RES)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Addition (10 + 20)", test_num);
        A = 8'd10;
        B = 8'd20;
        ADDSUB = 1'b0;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition with Overflow (250 + 10)", test_num);
        A = 8'd250;
        B = 8'd10;
        ADDSUB = 1'b0;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
        A = 8'd50;
        B = 8'd20;
        ADDSUB = 1'b1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction with Underflow (10 - 20)", test_num);
        A = 8'd10;
        B = 8'd20;
        ADDSUB = 1'b1;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition of Zero", test_num);
        A = 8'd0;
        B = 8'd0;
        ADDSUB = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction resulting in Zero", test_num);
        A = 8'd128;
        B = 8'd128;
        ADDSUB = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Max values Addition (255 + 255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        ADDSUB = 1'b0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Max value Subtraction (255 - 0)", test_num);
        A = 8'hFF;
        B = 8'h00;
        ADDSUB = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Zero minus One (0 - 1)", test_num);
        A = 8'h00;
        B = 8'h01;
        ADDSUB = 1'b1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_RES;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
