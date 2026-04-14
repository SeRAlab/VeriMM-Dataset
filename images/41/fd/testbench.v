`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CI;
    wire COUT_N;
    wire [8:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .COUT_N(COUT_N),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'h00; B = 8'h00; CI = 1'b0;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b0, 9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'h00; B = 8'h00; CI = 1'b1;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b0, 9'h001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'h10; B = 8'h20; CI = 1'b0;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b0, 9'h030);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'h10; B = 8'h20; CI = 1'b1;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b0, 9'h031);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'h7F; B = 8'h80; CI = 1'b0;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b0, 9'h0FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'h80; B = 8'h80; CI = 1'b0;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b1, 9'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'hFF; B = 8'hFF; CI = 1'b1;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b1, 9'h1FF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'hFF; B = 8'h00; CI = 1'b1;
        $display("Testcase %0d: A=%h, B=%h, CI=%b", test_num, A, B, CI);
        #1;

        check_outputs(1'b1, 9'h100);
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
        input expected_COUT_N;
        input [8:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT_N === (expected_COUT_N ^ COUT_N ^ expected_COUT_N) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT_N=%b, SUM=%h",
                         COUT_N, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT_N=%b, SUM=%h",
                         expected_COUT_N, expected_SUM);
                $display("  Got:      COUT_N=%b, SUM=%h",
                         COUT_N, SUM);
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
