`timescale 1ns/1ps

module array_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    array_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            $display("Test Case 001: 0 x 0");
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: 15 x 0");
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: 0 x 15");
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: 1 x 1");
            A = 4'd1;
            B = 4'd1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: 15 x 1");
            A = 4'd15;
            B = 4'd1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: 1 x 15");
            A = 4'd1;
            B = 4'd15;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: 15 x 15 (Max value)");
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: 10 x 10");
            A = 4'd10;
            B = 4'd10;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: 3 x 5");
            A = 4'd3;
            B = 4'd5;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: 7 x 9");
            A = 4'd7;
            B = 4'd9;
            #1;

            check_outputs(8'd63);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: 12 x 4");
            A = 4'd12;
            B = 4'd4;
            #1;

            check_outputs(8'd48);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: 13 x 11");
            A = 4'd13;
            B = 4'd11;
            #1;

            check_outputs(8'd143);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("array_multiplier Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
