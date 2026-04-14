`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] shift;
    reg [5:0] x;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .shift(shift),
        .x(x),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 0 (x=110101)", test_num);
            x = 6'b110101;
            shift = 4'b0000;
            #1;

            check_outputs(12'b10_xxxx_110101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 0 (x=110101)", test_num);
            x = 6'b110101;
            shift = 4'b0001;
            #1;

            check_outputs(12'b10_xxxx_110101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 1 (x=110101 -> 101010)", test_num);
            x = 6'b110101;
            shift = 4'b0010;
            #1;

            check_outputs(12'b10_xxxx_101010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 1 (x=110101 -> 011010)", test_num);
            x = 6'b110101;
            shift = 4'b0011;
            #1;

            check_outputs(12'b10_xxxx_011010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 2 (x=110101 -> 010100)", test_num);
            x = 6'b110101;
            shift = 4'b0100;
            #1;

            check_outputs(12'b10_xxxx_010100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 2 (x=110101 -> 001101)", test_num);
            x = 6'b110101;
            shift = 4'b0101;
            #1;

            check_outputs(12'b10_xxxx_001101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 5 (x=111111 -> 100000)", test_num);
            x = 6'b111111;
            shift = 4'b1010;
            #1;

            check_outputs(12'b10_xxxx_100000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 5 (x=111111 -> 000001)", test_num);
            x = 6'b111111;
            shift = 4'b1011;
            #1;

            check_outputs(12'b10_xxxx_000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 6 (x=111111 -> 000000)", test_num);
            x = 6'b111111;
            shift = 4'b1100;
            #1;

            check_outputs(12'b10_xxxx_000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 7 (x=111111 -> 000000)", test_num);
            x = 6'b111111;
            shift = 4'b1111;
            #1;

            check_outputs(12'b10_xxxx_000000);
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
        input [11:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
