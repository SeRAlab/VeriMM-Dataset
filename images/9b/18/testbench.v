`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Increment zero", test_num);
            in = 64'h0000000000000000;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Increment maximum value (rollover)", test_num);
            in = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Increment mid-range boundary (32-bit carry)", test_num);
            in = 64'h00000000FFFFFFFF;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Increment signed boundary", test_num);
            in = 64'h7FFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Increment penultimate value", test_num);
            in = 64'hFFFFFFFFFFFFFFFE;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Increment a random hex pattern", test_num);
            in = 64'hA5A5A5A5A5A5A5A5;
            #1;

            check_outputs(64'hA5A5A5A5A5A5A5A6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Increment simple decimal value", test_num);
            in = 64'd123456789;
            #1;

            check_outputs(64'd123456790);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Increment bit pattern with many carries", test_num);
            in = 64'h0000FFFFFFFFFFFF;
            #1;

            check_outputs(64'h0001000000000000);
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
        input [63:0] expected_out;
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
