`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    wire V;
    wire [2:0] outputWire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .V(V),
        .outputWire(outputWire)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs low", test_num);
            D = 8'b00000000;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Only D[0] active", test_num);
            D = 8'b00000001;
            #1;

            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only D[1] active", test_num);
            D = 8'b00000010;
            #1;

            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only D[2] active", test_num);
            D = 8'b00000100;
            #1;

            check_outputs(1'b1, 3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Only D[3] active", test_num);
            D = 8'b00001000;
            #1;

            check_outputs(1'b1, 3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Only D[4] active", test_num);
            D = 8'b00010000;
            #1;

            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Only D[5] active", test_num);
            D = 8'b00100000;
            #1;

            check_outputs(1'b1, 3'b101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Only D[6] active", test_num);
            D = 8'b01000000;
            #1;

            check_outputs(1'b1, 3'b110);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Only D[7] active", test_num);
            D = 8'b10000000;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Multiple bits active (D[7] highest)", test_num);
            D = 8'b10110001;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Multiple bits active (D[4] highest)", test_num);
            D = 8'b00011111;
            #1;

            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Multiple bits active (D[1] highest)", test_num);
            D = 8'b00000011;
            #1;

            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: All bits active", test_num);
            D = 8'b11111111;
            #1;

            check_outputs(1'b1, 3'b111);
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
        testcase013();
        
        
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
        input expected_V;
        input [2:0] expected_outputWire;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_outputWire === (expected_outputWire ^ outputWire ^ expected_outputWire)) begin
                $display("PASS");
                $display("  Outputs: V=%b, outputWire=%h",
                         V, outputWire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, outputWire=%h",
                         expected_V, expected_outputWire);
                $display("  Got:      V=%b, outputWire=%h",
                         V, outputWire);
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
