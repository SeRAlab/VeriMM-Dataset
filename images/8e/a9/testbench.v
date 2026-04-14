`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] U;
    reg [3:0] V;
    reg s;
    wire [3:0] M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .U(U),
        .V(V),
        .s(s),
        .M(M)
    );
    task testcase001;

        begin
            test_num = 1;
            s = 1'b0;
            U = 4'hA;
            V = 4'h5;
            $display("Test %0d: Select U (s=0), U=4'hA, V=4'h5", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            s = 1'b1;
            U = 4'hA;
            V = 4'h5;
            $display("Test %0d: Select V (s=1), U=4'hA, V=4'h5", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            s = 1'b0;
            U = 4'hF;
            V = 4'h0;
            $display("Test %0d: Select U (s=0), U=4'hF, V=4'h0", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            s = 1'b1;
            U = 4'hF;
            V = 4'h0;
            $display("Test %0d: Select V (s=1), U=4'hF, V=4'h0", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            s = 1'b0;
            U = 4'b1010;
            V = 4'b1100;
            $display("Test %0d: Select U (s=0), bitwise check", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            s = 1'b1;
            U = 4'b1010;
            V = 4'b1100;
            $display("Test %0d: Select V (s=1), bitwise check", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            s = 1'b0;
            U = 4'h9;
            V = 4'h3;
            $display("Test %0d: Select U (s=0), U=4'h9, V=4'h3", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            s = 1'b1;
            U = 4'h9;
            V = 4'h3;
            $display("Test %0d: Select V (s=1), U=4'h9, V=4'h3", test_num);
            #1;

            check_outputs(4'h3);
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
        input [3:0] expected_M;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M === (expected_M ^ M ^ expected_M)) begin
                $display("PASS");
                $display("  Outputs: M=%h",
                         M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%h",
                         expected_M);
                $display("  Got:      M=%h",
                         M);
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
