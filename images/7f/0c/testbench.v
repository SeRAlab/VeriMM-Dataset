`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sum(sum)
    );
    task testcase001;

        begin
            A = 8'h00; B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            A = 8'h12; B = 8'h34;
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase003;

        begin
            A = 8'h0F; B = 8'h01;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            A = 8'hAA; B = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            A = 8'hFF; B = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            A = 8'hFF; B = 8'hFF;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            A = 8'h80; B = 8'h80;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            A = 8'h7F; B = 8'h01;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_sum;
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
