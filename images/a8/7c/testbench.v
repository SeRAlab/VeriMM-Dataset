`timescale 1ns/1ps

module subtractor4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg bin;
    wire bout;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor4bit dut (
        .a(a),
        .b(b),
        .bin(bin),
        .bout(bout),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic subtraction (a > b, bin=0)", test_num);
            a = 4'd12; b = 4'd4; bin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic subtraction with bin (a > b, bin=1)", test_num);
            a = 4'd12; b = 4'd4; bin = 1'b1;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equality case (a == b, bin=0)", test_num);
            a = 4'd7; b = 4'd7; bin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow resulting in borrow (a < b)", test_num);
            a = 4'd5; b = 4'd10; bin = 1'b0;

            #1;


            check_outputs(1'b1, 4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum underflow (0 - 15 - 1)", test_num);
            a = 4'd0; b = 4'd15; bin = 1'b1;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros with borrow in", test_num);
            a = 4'd0; b = 4'd0; bin = 1'b1;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values (15 - 15 - 1)", test_num);
            a = 4'd15; b = 4'd15; bin = 1'b1;

            #1;


            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction from 15 with bin=0", test_num);
            a = 4'd15; b = 4'd5; bin = 1'b0;
            #1;

            check_outputs(1'b0, 4'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor4bit Testbench");
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
