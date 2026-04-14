`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg SUB;
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SUB(SUB),
        .in0(in0),
        .in1(in1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (SUB=0) - 0 + 0", test_num);
            SUB = 1'b0; in0 = 4'h0; in1 = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (SUB=0) - 5 + 3", test_num);
            SUB = 1'b0; in0 = 4'h5; in1 = 4'h3;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (SUB=0) - F + 1 (Overflow)", test_num);
            SUB = 1'b0; in0 = 4'hF; in1 = 4'h1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (SUB=0) - A + 5", test_num);
            SUB = 1'b0; in0 = 4'hA; in1 = 4'h5;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (SUB=1) - 5 - 3", test_num);
            SUB = 1'b1; in0 = 4'h5; in1 = 4'h3;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (SUB=1) - 3 - 5 (Negative result)", test_num);
            SUB = 1'b1; in0 = 4'h3; in1 = 4'h5;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (SUB=1) - 0 - 1", test_num);
            SUB = 1'b1; in0 = 4'h0; in1 = 4'h1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (SUB=1) - F - F", test_num);
            SUB = 1'b1; in0 = 4'hF; in1 = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (SUB=1) - 8 - 1", test_num);
            SUB = 1'b1; in0 = 4'h8; in1 = 4'h1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (SUB=0) - 8 + 8 (Overflow)", test_num);
            SUB = 1'b0; in0 = 4'h8; in1 = 4'h8;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
