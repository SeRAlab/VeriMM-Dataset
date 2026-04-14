`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg E3;
    reg nE1;
    reg nE2;
    wire [7:0] nY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .E3(E3),
        .nE1(nE1),
        .nE2(nE2),
        .nY(nY)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Enabled, A = 0", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Enabled, A = 1", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd1;
        #1;

        check_outputs(8'hFD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Enabled, A = 2", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd2;
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Enabled, A = 3", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd3;
        #1;

        check_outputs(8'hF7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Enabled, A = 4", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd4;
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Enabled, A = 5", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd5;
        #1;

        check_outputs(8'hDF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Enabled, A = 6", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd6;
        #1;

        check_outputs(8'hBF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Enabled, A = 7", test_num);
        nE1 = 0; nE2 = 0; E3 = 1; A = 3'd7;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Disabled (nE1=1), A = 0", test_num);
        nE1 = 1; nE2 = 0; E3 = 1; A = 3'd0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Disabled (nE2=1), A = 3", test_num);
        nE1 = 0; nE2 = 1; E3 = 1; A = 3'd3;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Disabled (E3=0), A = 7", test_num);
        nE1 = 0; nE2 = 0; E3 = 0; A = 3'd7;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Disabled (nE1=1, nE2=1, E3=0), A = 4", test_num);
        nE1 = 1; nE2 = 1; E3 = 0; A = 3'd4;
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_nY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nY === (expected_nY ^ nY ^ expected_nY)) begin
                $display("PASS");
                $display("  Outputs: nY=%h",
                         nY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nY=%h",
                         expected_nY);
                $display("  Got:      nY=%h",
                         nY);
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
