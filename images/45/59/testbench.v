`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd0;
            b = 4'd0;
            $display("Testcase 001: Addition of zeros (0 + 0)");
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd15;
            b = 4'd15;
            $display("Testcase 002: Maximum values (15 + 15)");
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd15;
            b = 4'd1;
            $display("Testcase 003: Boundary carry-out (15 + 1)");
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd5;
            b = 4'd10;
            $display("Testcase 004: Standard addition without carry-out (5 + 10)");
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd8;
            b = 4'd8;
            $display("Testcase 005: Power of two carry (8 + 8)");
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd1;
            b = 4'd2;
            $display("Testcase 006: Small values (1 + 2)");
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd12;
            b = 4'd13;
            $display("Testcase 007: Large values with carry-out (12 + 13)");
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'd7;
            b = 4'd9;
            $display("Testcase 008: Mixed values (7 + 9)");
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'd14;
            b = 4'd1;
            $display("Testcase 009: Max minus one plus one (14 + 1)");
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 4'd3;
            b = 4'd4;
            $display("Testcase 010: Small values (3 + 4)");
            #1;

            check_outputs(5'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
        input [4:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
