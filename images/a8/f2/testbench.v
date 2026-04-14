`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] check;
    reg [127:0] in;
    wire error;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check(check),
        .in(in),
        .error(error),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (Check Match)", test_num);


            in = 128'h0;
            check = 16'h1001;
            #1;

            check_outputs(1'b0, 16'h1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (Check Match)", test_num);



            in = 128'h01010101010101010101010101010101;
            check = 16'h9811;
            #1;

            check_outputs(1'b0, 16'h9811);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Byte Sequence 0-15 (Check Match)", test_num);




            in = 128'h0f0e0d0c0b0a09080706050403020100;
            check = 16'hC279;
            #1;

            check_outputs(1'b0, 16'hC279);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All 0xFF (Check Match)", test_num);




            in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            check = 16'h3A41;
            #1;

            check_outputs(1'b0, 16'h3A41);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Error Flag Test (Mismatch)", test_num);

            in = 128'h0;
            check = 16'h0000;
            #1;

            check_outputs(1'b1, 16'h1001);
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
        input expected_error;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: error=%b, out=%h",
                         error, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, out=%h",
                         expected_error, expected_out);
                $display("  Got:      error=%b, out=%h",
                         error, out);
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
