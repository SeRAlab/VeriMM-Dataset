`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] hex;
    wire [3:0] ones;
    wire tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex(hex),
        .ones(ones),
        .tens(tens)
    );
    task testcase001;

        begin
            test_num = 1;
            hex = 5'd0;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            hex = 5'd9;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd9, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            hex = 5'd10;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            hex = 5'd15;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            hex = 5'd19;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            hex = 5'd20;
            $display("Test %0d: hex = %d", test_num, hex);

            #1;


            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            hex = 5'd27;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd7, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            hex = 5'd31;
            $display("Test %0d: hex = %d", test_num, hex);
            #1;

            check_outputs(4'd1, 1'b1);
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
        input [3:0] expected_ones;
        input expected_tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens)) begin
                $display("PASS");
                $display("  Outputs: ones=%h, tens=%b",
                         ones, tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones=%h, tens=%b",
                         expected_ones, expected_tens);
                $display("  Got:      ones=%h, tens=%b",
                         ones, tens);
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
