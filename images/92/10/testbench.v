`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] B;
    reg C;
    reg D;
    reg E;
    wire X;

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
        .E(E),
        .X(X)
    );
    task testcase001;

        begin
            A = 4'd3; B = 2'd2; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            A = 4'd6; B = 2'd2; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            A = 4'd2; B = 2'd1; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            A = 4'd10; B = 2'd0; C = 1; D = 0; E = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            A = 4'd10; B = 2'd0; C = 0; D = 0; E = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            A = 4'd10; B = 2'd0; C = 1; D = 1; E = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            A = 4'd10; B = 2'd0; C = 1; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            A = 4'd5; B = 2'd2; C = 1; D = 0; E = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            A = 4'd5; B = 2'd2; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            A = 4'd0; B = 2'd0; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
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
