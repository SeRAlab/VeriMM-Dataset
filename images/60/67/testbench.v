`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] V;
    wire [3:0] A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .V(V),
        .A(A)
    );
    task testcase001;

        begin
            test_num = 1;
            V = 3'b000;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            V = 3'b001;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            V = 3'b010;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            V = 3'b011;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            V = 3'b100;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            V = 3'b101;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            V = 3'b110;

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            V = 3'b111;

            #1;


            check_outputs(4'h5);
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
        input [3:0] expected_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%h",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h",
                         expected_A);
                $display("  Got:      A=%h",
                         A);
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
