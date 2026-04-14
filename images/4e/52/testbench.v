`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] A;
    reg [13:0] B;
    reg CI;
    wire CO;
    wire [13:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CI(CI),
        .CO(CO),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 14'h0000; B = 14'h0000; CI = 1'b0;
        #1;

        check_outputs(1'b0, 14'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 14'h0000; B = 14'h0000; CI = 1'b1;
        #1;

        check_outputs(1'b0, 14'h0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 14'h0005; B = 14'h000A; CI = 1'b0;
        #1;

        check_outputs(1'b0, 14'h000F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 14'h3FFF; B = 14'h0000; CI = 1'b0;
        #1;

        check_outputs(1'b0, 14'h3FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 14'h0000; B = 14'h3FFF; CI = 1'b0;
        #1;

        check_outputs(1'b0, 14'h3FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 14'h3FFF; B = 14'h0000; CI = 1'b1;
        #1;

        check_outputs(1'b1, 14'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 14'h2000; B = 14'h2000; CI = 1'b0;
        #1;

        check_outputs(1'b1, 14'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 14'h1555; B = 14'h2AAA; CI = 1'b0;
        #1;

        check_outputs(1'b0, 14'h3FFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 14'h3FFF; B = 14'h3FFF; CI = 1'b0;
        #1;

        check_outputs(1'b1, 14'h3FFE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 14'h3FFF; B = 14'h3FFF; CI = 1'b1;
        #1;

        check_outputs(1'b1, 14'h3FFF);
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
        input expected_CO;
        input [13:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, SUM=%h",
                         CO, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, SUM=%h",
                         expected_CO, expected_SUM);
                $display("  Got:      CO=%b, SUM=%h",
                         CO, SUM);
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
