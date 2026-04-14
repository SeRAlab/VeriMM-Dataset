`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire EN;
    wire [2:0] Q;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .EN(EN),
        .Q(Q),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs inactive", test_num);
            I = 8'b00000000;
            #1;

            check_outputs(1'b0, 3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 0 only", test_num);
            I = 8'b00000001;
            #1;

            check_outputs(1'b1, 3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 7 only", test_num);
            I = 8'b10000000;
            #1;

            check_outputs(1'b1, 3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (7 is highest)", test_num);
            I = 8'b10101010;
            #1;

            check_outputs(1'b1, 3'd7, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple inputs (3 is highest)", test_num);
            I = 8'b00001111;
            #1;

            check_outputs(1'b1, 3'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 4 only", test_num);
            I = 8'b00010000;
            #1;

            check_outputs(1'b1, 3'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bits 1 and 0 (1 is highest)", test_num);
            I = 8'b00000011;
            #1;

            check_outputs(1'b1, 3'd1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits active", test_num);
            I = 8'b11111111;
            #1;

            check_outputs(1'b1, 3'd7, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 6 only", test_num);
            I = 8'b01000000;
            #1;

            check_outputs(1'b1, 3'd6, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits (5 is highest)", test_num);
            I = 8'b00100110;
            #1;

            check_outputs(1'b1, 3'd5, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input bit 2 only", test_num);
            I = 8'b00000100;
            #1;

            check_outputs(1'b1, 3'd2, 1'b1);
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
        input expected_EN;
        input [2:0] expected_Q;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Q=%h, V=%b",
                         EN, Q, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Q=%h, V=%b",
                         expected_EN, expected_Q, expected_V);
                $display("  Got:      EN=%b, Q=%h, V=%b",
                         EN, Q, V);
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
