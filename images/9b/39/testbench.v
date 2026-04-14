`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .xor_out(xor_out)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 4'b0000;
            in1 = 4'b0000;
            #5;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 4'b1111;
            in1 = 4'b1111;
            #5;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 4'b1010;
            in1 = 4'b0101;
            #5;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 4'b1100;
            in1 = 4'b0000;
            #5;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 4'b0001;
            in1 = 4'b0011;
            #5;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 4'b1000;
            in1 = 4'b1111;
            #5;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0 = 4'hA;
            in1 = 4'hC;
            #5;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 4'h7;
            in1 = 4'h2;
            #5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in0 = 4'h2;
            in1 = 4'h7;
            #5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in0 = 4'hF;
            in1 = 4'h0;
            #5;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_xor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: xor_out=%h",
                         xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xor_out=%h",
                         expected_xor_out);
                $display("  Got:      xor_out=%h",
                         xor_out);
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
