`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D0;
    reg [3:0] D1;
    reg Seleccion;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .Seleccion(Seleccion),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select D0 (D0=5, D1=A, Sel=0)", test_num);
            Seleccion = 1'b0;
            D0 = 4'h5;
            D1 = 4'hA;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select D1 (D0=5, D1=A, Sel=1)", test_num);
            Seleccion = 1'b1;
            D0 = 4'h5;
            D1 = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select D0 (D0=F, D1=0, Sel=0)", test_num);
            Seleccion = 1'b0;
            D0 = 4'hF;
            D1 = 4'h0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select D1 (D0=F, D1=0, Sel=1)", test_num);
            Seleccion = 1'b1;
            D0 = 4'hF;
            D1 = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select D0 (D0=9, D1=6, Sel=0)", test_num);
            Seleccion = 1'b0;
            D0 = 4'h9;
            D1 = 4'h6;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select D1 (D0=9, D1=6, Sel=1)", test_num);
            Seleccion = 1'b1;
            D0 = 4'h9;
            D1 = 4'h6;
            #1;

            check_outputs(4'h6);
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
        input [3:0] expected_Y;
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
