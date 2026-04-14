`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg ci;
    wire co;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ci(ci),
        .co(co),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            a = 4'h0; b = 4'h0; ci = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small addition, no carry out", test_num);
            a = 4'h3; b = 4'h4; ci = 1'b0;
            #1;

            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-in only", test_num);
            a = 4'h0; b = 4'h0; ci = 1'b1;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry out", test_num);
            a = 4'h7; b = 4'h8; ci = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum carry out (15 + 1)", test_num);
            a = 4'hF; b = 4'h1; ci = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary carry out (8 + 8)", test_num);
            a = 4'h8; b = 4'h8; ci = 1'b0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible values (15 + 15 + 1)", test_num);
            a = 4'hF; b = 4'hF; ci = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random combination with carry out (10 + 5 + 1)", test_num);
            a = 4'hA; b = 4'h5; ci = 1'b1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values (5 + 5 + 0)", test_num);
            a = 4'h5; b = 4'h5; ci = 1'b0;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation (7 + 8 + 1)", test_num);
            a = 4'h7; b = 4'h8; ci = 1'b1;
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
        input expected_co;
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_co === (expected_co ^ co ^ expected_co) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: co=%b, s=%h",
                         co, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co=%b, s=%h",
                         expected_co, expected_s);
                $display("  Got:      co=%b, s=%h",
                         co, s);
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
