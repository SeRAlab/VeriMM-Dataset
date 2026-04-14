`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg [1:0] Ctrl;
    reg [15:0] D;
    wire [15:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Ctrl(Ctrl),
        .D(D),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input A (Ctrl = 00)", test_num);
            A = 16'hAAAA;
            B = 16'hBBBB;
            C = 16'hCCCC;
            D = 16'hDDDD;
            Ctrl = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input B (Ctrl = 01)", test_num);
            A = 16'hAAAA;
            B = 16'hBBBB;
            C = 16'hCCCC;
            D = 16'hDDDD;
            Ctrl = 2'b01;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input C (Ctrl = 10)", test_num);
            A = 16'hAAAA;
            B = 16'hBBBB;
            C = 16'hCCCC;
            D = 16'hDDDD;
            Ctrl = 2'b10;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Input D (Ctrl = 11)", test_num);
            A = 16'hAAAA;
            B = 16'hBBBB;
            C = 16'hCCCC;
            D = 16'hDDDD;
            Ctrl = 2'b11;
            #1;

            check_outputs(16'hDDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs same value", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            C = 16'hFFFF;
            D = 16'hFFFF;
            Ctrl = 2'b10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Distinct bit patterns (Alternating)", test_num);
            A = 16'h5555;
            B = 16'h0000;
            C = 16'hFFFF;
            D = 16'h1234;
            Ctrl = 2'b00;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking B with Zero value", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            C = 16'hFFFF;
            D = 16'hFFFF;
            Ctrl = 2'b01;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
