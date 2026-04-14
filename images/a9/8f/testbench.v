`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    reg op;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Unsigned Addition (Small numbers)", test_num);
            op = 0;
            in1 = 16'd100;
            in2 = 16'd250;
            #10;
            #1;

            check_outputs(16'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Unsigned Addition (Wrap around)", test_num);
            op = 0;
            in1 = 16'hFFFF;
            in2 = 16'h0001;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Signed Addition (Positive + Negative)", test_num);
            op = 1;
            in1 = 16'sh000A;
            in2 = 16'shFFFF;
            #10;
            #1;

            check_outputs(16'sh0009);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Signed Addition (Negative + Negative)", test_num);
            op = 1;
            in1 = 16'shFFFE;
            in2 = 16'shFFFD;
            #10;
            #1;

            check_outputs(16'shFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Signed Addition (Max Positive + 1)", test_num);
            op = 1;
            in1 = 16'h7FFF;
            in2 = 16'h0001;
            #10;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Unsigned Addition (Large inputs)", test_num);
            op = 0;
            in1 = 16'h8000;
            in2 = 16'h8000;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Zero addition", test_num);
            op = 0;
            in1 = 16'h0000;
            in2 = 16'h0000;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Signed addition resulting in zero", test_num);
            op = 1;
            in1 = 16'sh7FFF;
            in2 = 16'sh8001;
            #10;
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
        input [15:0] expected_out;
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
