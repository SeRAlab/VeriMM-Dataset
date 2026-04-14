`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] out;
    wire out1;
    wire out2;
    wire out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 0", test_num);
            in = 8'd0;

            #1;


            check_outputs(8'd0, 8'd42, 8'd65, 8'd23);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 10", test_num);
            in = 8'd10;

            #1;


            check_outputs(8'd0, 8'd52, 8'd75, 8'd33);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 100", test_num);
            in = 8'd100;

            #1;


            check_outputs(8'd0, 8'd142, 8'd165, 8'd123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 214 (Boundary for out1)", test_num);
            in = 8'd214;

            #1;


            check_outputs(8'd0, 8'd0, 8'd23, 8'd237);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 255 (Max value)", test_num);
            in = 8'd255;

            #1;


            check_outputs(8'd0, 8'd41, 8'd64, 8'd22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input = 127", test_num);
            in = 8'd127;

            #1;


            check_outputs(8'd0, 8'd169, 8'd192, 8'd150);
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
        input [7:0] expected_out;
        input expected_out1;
        input expected_out2;
        input expected_out3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out1=%b, out2=%b, out3=%b",
                         out, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out1=%b, out2=%b, out3=%b",
                         expected_out, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out=%h, out1=%b, out2=%b, out3=%b",
                         out, out1, out2, out3);
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
