`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd0;
            b = 4'd0;
            $display("Test %0d: Zero Case (0 * 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd15;
            b = 4'd15;
            $display("Test %0d: Maximum Values (15 * 15)", test_num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'd0;
            b = 4'd15;
            $display("Test %0d: Zero and Max (0 * 15)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd1;
            b = 4'd10;
            $display("Test %0d: Identity (1 * 10)", test_num);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'd2;
            b = 4'd4;
            $display("Test %0d: Power of 2 (2 * 4)", test_num);
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'd8;
            b = 4'd8;
            $display("Test %0d: Mid-range Power of 2 (8 * 8)", test_num);
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'd7;
            b = 4'd13;
            $display("Test %0d: Prime Product (7 * 13)", test_num);
            #1;

            check_outputs(8'd91);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'd11;
            b = 4'd11;
            $display("Test %0d: Square (11 * 11)", test_num);
            #1;

            check_outputs(8'd121);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'd14;
            b = 4'd3;
            $display("Test %0d: Random Case A (14 * 3)", test_num);
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'd5;
            b = 4'd9;
            $display("Test %0d: Random Case B (5 * 9)", test_num);
            #1;

            check_outputs(8'd45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
