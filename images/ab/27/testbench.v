`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Sel;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select A (A=4'h5, B=4'hA, Sel=0)", test_num);
        A = 4'h5;
        B = 4'hA;
        Sel = 1'b0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select B (A=4'h5, B=4'hA, Sel=1)", test_num);
        A = 4'h5;
        B = 4'hA;
        Sel = 1'b1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: All ones on A (A=4'hF, B=4'h0, Sel=0)", test_num);
        A = 4'hF;
        B = 4'h0;
        Sel = 1'b0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All ones on B (A=4'h0, B=4'hF, Sel=1)", test_num);
        A = 4'h0;
        B = 4'hF;
        Sel = 1'b1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bits (A=4'b1010, B=4'b0101, Sel=0)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        Sel = 1'b0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating bits (A=4'b1010, B=4'b0101, Sel=1)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        Sel = 1'b1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Zero inputs (A=4'h0, B=4'h0, Sel=0)", test_num);
        A = 4'h0;
        B = 4'h0;
        Sel = 1'b0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Random pattern (A=4'h3, B=4'hC, Sel=0)", test_num);
        A = 4'h3;
        B = 4'hC;
        Sel = 1'b0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Random pattern (A=4'h3, B=4'hC, Sel=1)", test_num);
        A = 4'h3;
        B = 4'hC;
        Sel = 1'b1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Edge case values (A=4'h7, B=4'hE, Sel=0)", test_num);
        A = 4'h7;
        B = 4'hE;
        Sel = 1'b0;
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
