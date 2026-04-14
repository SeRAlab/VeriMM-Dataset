`timescale 1ns/1ps

module subtractor_tb;

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
    subtractor dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd10;
            b = 4'd4;
            $display("\nTest %0d: a=%d, b=%d (Normal subtraction)", test_num, a, b);
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd4;
            b = 4'd10;
            $display("\nTest %0d: a=%d, b=%d (Subtraction with borrow)", test_num, a, b);

            #1;


            check_outputs(1'b1, 4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd15;
            b = 4'd15;
            $display("\nTest %0d: a=%d, b=%d (Equal values)", test_num, a, b);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd0;
            b = 4'd1;
            $display("\nTest %0d: a=%d, b=%d (Zero minus one)", test_num, a, b);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd15;
            b = 4'd0;
            $display("\nTest %0d: a=%d, b=%d (Max minus zero)", test_num, a, b);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd1;
            b = 4'd1;
            $display("\nTest %0d: a=%d, b=%d (Smallest non-zero values)", test_num, a, b);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd7;
            b = 4'd8;
            $display("\nTest %0d: a=%d, b=%d (Power of 2 threshold)", test_num, a, b);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'd0;
            b = 4'd15;
            $display("\nTest %0d: a=%d, b=%d (Min minus Max)", test_num, a, b);
            #1;

            check_outputs(1'b1, 4'd1);
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
