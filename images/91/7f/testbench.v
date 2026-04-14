`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x0;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    reg [3:0] x4;
    reg [3:0] x5;
    reg [3:0] x6;
    reg [3:0] x7;
    reg [3:0] x8;
    reg [3:0] x9;
    reg [3:0] xA;
    reg [3:0] xB;
    reg [3:0] xC;
    reg [3:0] xD;
    reg [3:0] xE;
    reg [3:0] xF;
    wire [63:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .x8(x8),
        .x9(x9),
        .xA(xA),
        .xB(xB),
        .xC(xC),
        .xD(xD),
        .xE(xE),
        .xF(xF),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            x0 = 4'h0; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            x4 = 4'h0; x5 = 4'h0; x6 = 4'h0; x7 = 4'h0;
            x8 = 4'h0; x9 = 4'h0; xA = 4'h0; xB = 4'h0;
            xC = 4'h0; xD = 4'h0; xE = 4'h0; xF = 4'h0;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            x0 = 4'hF; x1 = 4'hF; x2 = 4'hF; x3 = 4'hF;
            x4 = 4'hF; x5 = 4'hF; x6 = 4'hF; x7 = 4'hF;
            x8 = 4'hF; x9 = 4'hF; xA = 4'hF; xB = 4'hF;
            xC = 4'hF; xD = 4'hF; xE = 4'hF; xF = 4'hF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Incremental Hex Values (0 to F)", test_num);
            x0 = 4'h0; x1 = 4'h1; x2 = 4'h2; x3 = 4'h3;
            x4 = 4'h4; x5 = 4'h5; x6 = 4'h6; x7 = 4'h7;
            x8 = 4'h8; x9 = 4'h9; xA = 4'hA; xB = 4'hB;
            xC = 4'hC; xD = 4'hD; xE = 4'hE; xF = 4'hF;

            #1;


            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decremental Hex Values (F to 0)", test_num);
            x0 = 4'hF; x1 = 4'hE; x2 = 4'hD; x3 = 4'hC;
            x4 = 4'hB; x5 = 4'hA; x6 = 4'h9; x7 = 4'h8;
            x8 = 4'h7; x9 = 4'h6; xA = 4'h5; xB = 4'h4;
            xC = 4'h3; xD = 4'h2; xE = 4'h1; xF = 4'h0;
            #1;

            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern (5s and As)", test_num);
            x0 = 4'hA; x1 = 4'h5; x2 = 4'hA; x3 = 4'h5;
            x4 = 4'hA; x5 = 4'h5; x6 = 4'hA; x7 = 4'h5;
            x8 = 4'hA; x9 = 4'h5; xA = 4'hA; xB = 4'h5;
            xC = 4'hA; xD = 4'h5; xE = 4'hA; xF = 4'h5;

            #1;


            check_outputs(64'h5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only Endpoints Active", test_num);
            x0 = 4'h1; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            x4 = 4'h0; x5 = 4'h0; x6 = 4'h0; x7 = 4'h0;
            x8 = 4'h0; x9 = 4'h0; xA = 4'h0; xB = 4'h0;
            xC = 4'h0; xD = 4'h0; xE = 4'h0; xF = 4'h8;
            #1;

            check_outputs(64'h8000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Specific Middle Values", test_num);
            x0 = 4'h0; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            x4 = 4'h0; x5 = 4'h0; x6 = 4'h0; x7 = 4'hB;
            x8 = 4'hE; x9 = 4'hE; xA = 4'hF; xB = 4'h0;
            xC = 4'h0; xD = 4'h0; xE = 4'h0; xF = 4'h0;

            #1;


            check_outputs(64'h00000FEEB0000000);
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
        input [63:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
