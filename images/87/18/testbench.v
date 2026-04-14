`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [3:0] y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .y1(y1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            a = 4'h0;
            b = 4'h0;
            c = 4'h0;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs high", test_num);
            a = 4'hF;
            b = 4'hF;
            c = 4'hF;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input c is all ones, others zero", test_num);
            a = 4'h0;
            b = 4'h0;
            c = 4'hF;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern 1", test_num);
            a = 4'h5;
            b = 4'hA;
            c = 4'h5;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits pattern 2", test_num);
            a = 4'hA;
            b = 4'h0;
            c = 4'hC;

            #1;


            check_outputs(4'hB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set pattern", test_num);
            a = 4'h1;
            b = 4'h2;
            c = 4'h4;

            #1;


            check_outputs(4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bit manipulation", test_num);
            a = 4'h8;
            b = 4'h4;
            c = 4'h2;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify b-masking logic", test_num);
            a = 4'h3;
            b = 4'hC;
            c = 4'h3;

            #1;


            check_outputs(4'hF);
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
        input [3:0] expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y1=%h",
                         y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h",
                         expected_y1);
                $display("  Got:      y1=%h",
                         y1);
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
