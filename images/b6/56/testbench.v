`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg E;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .E(E),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test Case 001: Enable (E) is HIGH, Y should be LOW regardless of S and D");
            E = 1'b1;
            D = 8'hFF;
            S = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Enable (E) is HIGH, different S, Y should be LOW");
            E = 1'b1;
            D = 8'hFF;
            S = 3'b111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Enable (E) is LOW, S=000, D[0]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00000001;
            S = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Enable (E) is LOW, S=000, D[0]=0, Y should be 0");
            E = 1'b0;
            D = 8'b11111110;
            S = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Enable (E) is LOW, S=001, D[1]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00000010;
            S = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Enable (E) is LOW, S=010, D[2]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00000100;
            S = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Enable (E) is LOW, S=011, D[3]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00001000;
            S = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Enable (E) is LOW, S=100, D[4]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00010000;
            S = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Enable (E) is LOW, S=101, D[5]=1, Y should be 1");
            E = 1'b0;
            D = 8'b00100000;
            S = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Enable (E) is LOW, S=110, D[6]=1, Y should be 1");
            E = 1'b0;
            D = 8'b01000000;
            S = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Enable (E) is LOW, S=111, D[7]=1, Y should be 1");
            E = 1'b0;
            D = 8'b10000000;
            S = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Enable (E) is LOW, S=111, D[7]=0, Y should be 0");
            E = 1'b0;
            D = 8'b01111111;
            S = 3'b111;
            #1;

            check_outputs(1'b0);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
