`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire borrow_out;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtracting equal values (5 - 5)", test_num);
            a = 4'd5;
            b = 4'd5;

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a > b (10 - 4)", test_num);
            a = 4'd10;
            b = 4'd4;

            #1;


            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a < b (3 - 7)", test_num);
            a = 4'd3;
            b = 4'd7;

            #1;


            check_outputs(1'b1, 4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero minus Zero (0 - 0)", test_num);
            a = 4'd0;
            b = 4'd0;

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum minus Minimum (15 - 0)", test_num);
            a = 4'd15;
            b = 4'd0;

            #1;


            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum minus Maximum (0 - 15)", test_num);
            a = 4'd0;
            b = 4'd15;

            #1;


            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum minus one (15 - 1)", test_num);
            a = 4'd15;
            b = 4'd1;

            #1;


            check_outputs(1'b0, 4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrap around check (7 - 8)", test_num);
            a = 4'd7;
            b = 4'd8;

            #1;


            check_outputs(1'b1, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input expected_borrow_out;
        input [3:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
