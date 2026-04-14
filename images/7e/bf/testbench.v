`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A1;
    reg [2:0] A2;
    reg [2:0] B1;
    reg [2:0] B2;
    reg [2:0] C1;
    reg [2:0] C2;
    reg [2:0] D1;
    reg [2:0] D2;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .C2(C2),
        .D1(D1),
        .D2(D2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A1 = 3'd0; A2 = 3'd0; B1 = 3'd0; B2 = 3'd0;
        C1 = 3'd0; C2 = 3'd0; D1 = 3'd0; D2 = 3'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A1 = 3'd7; A2 = 3'd0; B1 = 3'd1; B2 = 3'd2;
        C1 = 3'd3; C2 = 3'd4; D1 = 3'd5; D2 = 3'd6;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A1 = 3'd1; A2 = 3'd2; B1 = 3'd3; B2 = 3'd4;
        C1 = 3'd5; C2 = 3'd6; D1 = 3'd0; D2 = 3'd7;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A1 = 3'd3; A2 = 3'd3; B1 = 3'd3; B2 = 3'd3;
        C1 = 3'd3; C2 = 3'd3; D1 = 3'd3; D2 = 3'd3;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A1 = 3'd1; A2 = 3'd1; B1 = 3'd5; B2 = 3'd2;
        C1 = 3'd4; C2 = 3'd3; D1 = 3'd0; D2 = 3'd1;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A1 = 3'd2; A2 = 3'd2; B1 = 3'd2; B2 = 3'd2;
        C1 = 3'd1; C2 = 3'd6; D1 = 3'd5; D2 = 3'd4;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A1 = 3'd4; A2 = 3'd0; B1 = 3'd4; B2 = 3'd1;
        C1 = 3'd2; C2 = 3'd4; D1 = 3'd3; D2 = 3'd4;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A1 = 3'd7; A2 = 3'd7; B1 = 3'd7; B2 = 3'd7;
        C1 = 3'd7; C2 = 3'd7; D1 = 3'd7; D2 = 3'd7;
        #1;

        check_outputs(3'd7);
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
        input [2:0] expected_Y;
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
