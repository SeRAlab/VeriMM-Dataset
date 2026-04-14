`timescale 1ns/1ps

module subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire bout;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor dut (
        .a(a),
        .b(b),
        .bout(bout),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Subtraction (No Borrow)", test_num);
            a = 4'h8;
            b = 4'h3;

            #1;


            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtracting Equal Values", test_num);
            a = 4'hA;
            b = 4'hA;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Borrow Required (a < b)", test_num);
            a = 4'h2;
            b = 4'h5;

            #1;


            check_outputs(1'b1, 4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtract from Zero (Max Borrow)", test_num);
            a = 4'h0;
            b = 4'h1;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values Subtracting Zero", test_num);
            a = 4'hF;
            b = 4'h0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values Subtracting Maximum", test_num);
            a = 4'hF;
            b = 4'hF;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero minus Max Value", test_num);
            a = 4'h0;
            b = 4'hF;

            #1;


            check_outputs(1'b1, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Subtraction", test_num);
            a = 4'h7;
            b = 4'h8;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor Testbench");
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
        input expected_bout;
        input [3:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bout === (expected_bout ^ bout ^ expected_bout) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: bout=%b, diff=%h",
                         bout, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%b, diff=%h",
                         expected_bout, expected_diff);
                $display("  Got:      bout=%b, diff=%h",
                         bout, diff);
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
