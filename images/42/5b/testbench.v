`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    reg SEL0;
    reg SEL1;
    reg [4:0] shift_amount;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .SEL0(SEL0),
        .SEL1(SEL1),
        .shift_amount(shift_amount),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A, Shift 0", test_num);
            A = 32'h12345678; B = 32'h0; C = 32'h0; D = 32'h0;
            SEL1 = 0; SEL0 = 0;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B, Left Shift 4", test_num);
            A = 32'h0; B = 32'h0000000F; C = 32'h0; D = 32'h0;
            SEL1 = 0; SEL0 = 1;
            shift_amount = 5'd4;
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select C, Left Shift 15", test_num);
            A = 32'h0; B = 32'h0; C = 32'h00000001; D = 32'h0;
            SEL1 = 1; SEL0 = 0;
            shift_amount = 5'd15;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D, Right Shift 1 (SA=-1)", test_num);
            A = 32'h0; B = 32'h0; C = 32'h0; D = 32'h80000000;
            SEL1 = 1; SEL0 = 1;
            shift_amount = 5'b11111;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A, Right Shift 16 (SA=-16)", test_num);
            A = 32'hABCD0123; B = 32'h0; C = 32'h0; D = 32'h0;
            SEL1 = 0; SEL0 = 0;
            shift_amount = 5'b10000;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B, Right Shift 8 (SA=-8)", test_num);
            A = 32'h0; B = 32'h12345678; C = 32'h0; D = 32'h0;
            SEL1 = 0; SEL0 = 1;
            shift_amount = 5'b11000;
            #1;

            check_outputs(32'h00123456);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select C, Max Left Shift 15", test_num);
            A = 32'h0; B = 32'h0; C = 32'hFFFFFFFF; D = 32'h0;
            SEL1 = 1; SEL0 = 0;
            shift_amount = 5'b01111;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D, Right Shift 4 (SA=-4)", test_num);
            A = 32'h0; B = 32'h0; C = 32'h0; D = 32'hF0F0F0F0;
            SEL1 = 1; SEL0 = 1;
            shift_amount = 5'b11100;
            #1;

            check_outputs(32'h0F0F0F0F);
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
