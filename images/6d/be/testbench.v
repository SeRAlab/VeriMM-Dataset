`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire [7:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        A = 8'h00; B = 8'h00; C = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All inputs FF", test_num);
        A = 8'hFF; B = 8'hFF; C = 8'hFF;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: B is 0 (X should equal C)", test_num);
        A = 8'hFF; B = 8'h00; C = 8'hAA;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: B is FF (X should equal ~A)", test_num);
        A = 8'h55; B = 8'hFF; C = 8'h00;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Disjoint bitmasks A and B", test_num);
        A = 8'h0F; B = 8'hF0; C = 8'hFF;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Identical A and B, distinct C", test_num);
        A = 8'hF0; B = 8'hF0; C = 8'h0F;

        #1;


        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Random bit patterns", test_num);
        A = 8'h12; B = 8'h34; C = 8'h56;

        #1;


        check_outputs(8'h66);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating bits", test_num);
        A = 8'hAA; B = 8'h55; C = 8'h33;

        #1;


        check_outputs(8'h77);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Overlapping bits", test_num);
        A = 8'hFF; B = 8'hAA; C = 8'h55;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Sparse bit check", test_num);
        A = 8'h11; B = 8'h22; C = 8'h44;

        #1;


        check_outputs(8'h66);
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
        input [7:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
