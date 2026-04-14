`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_1;
    wire cf;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_1(c_1),
        .cf(cf),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic addition without carry-in", test_num);
            a = 4'h2; b = 4'h3; c_1 = 1'b0;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic addition with carry-in", test_num);
            a = 4'h2; b = 4'h3; c_1 = 1'b1;
            #1;

            check_outputs(1'b0, 4'h6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Sum resulting in zero (no overflow)", test_num);
            a = 4'h0; b = 4'h0; c_1 = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Maximum sum without carry-out", test_num);
            a = 4'hA; b = 4'h5; c_1 = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Carry-out generated (15+1)", test_num);
            a = 4'hF; b = 4'h1; c_1 = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Carry-out generated with carry-in (15+0+1)", test_num);
            a = 4'hF; b = 4'h0; c_1 = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Maximum possible sum (15+15+1)", test_num);
            a = 4'hF; b = 4'hF; c_1 = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Bitwise carry propagation (7+1)", test_num);
            a = 4'h7; b = 4'h1; c_1 = 1'b0;
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Alternating bits", test_num);
            a = 4'hA; b = 4'h5; c_1 = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Mid-range overflow", test_num);
            a = 4'h8; b = 4'h8; c_1 = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
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
        input expected_cf;
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cf === (expected_cf ^ cf ^ expected_cf) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: cf=%b, y=%h",
                         cf, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cf=%b, y=%h",
                         expected_cf, expected_y);
                $display("  Got:      cf=%b, y=%h",
                         cf, y);
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
