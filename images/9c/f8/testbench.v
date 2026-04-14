`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] c;
    wire f4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .f4(f4)
    );
    task testcase001;

        begin
            test_num = 1;
            c = 8'b00000000;
            $display("Test %0d: Input c = %b (LSB is 0)", test_num, c);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            c = 8'b00000001;
            $display("Test %0d: Input c = %b (LSB is 1)", test_num, c);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            c = 8'b11111110;
            $display("Test %0d: Input c = %b (LSB is 0, high bits set)", test_num, c);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            c = 8'b11111111;
            $display("Test %0d: Input c = %b (LSB is 1, all bits set)", test_num, c);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            c = 8'b10101010;
            $display("Test %0d: Input c = %b (LSB is 0, alternating pattern)", test_num, c);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            c = 8'b01010101;
            $display("Test %0d: Input c = %b (LSB is 1, alternating pattern)", test_num, c);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            c = 8'b10000000;
            $display("Test %0d: Input c = %b (LSB is 0, only MSB set)", test_num, c);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            c = 8'h7F;
            $display("Test %0d: Input c = %b (LSB is 1, MSB is 0)", test_num, c);
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
        input expected_f4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f4 === (expected_f4 ^ f4 ^ expected_f4)) begin
                $display("PASS");
                $display("  Outputs: f4=%b",
                         f4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f4=%b",
                         expected_f4);
                $display("  Got:      f4=%b",
                         f4);
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
