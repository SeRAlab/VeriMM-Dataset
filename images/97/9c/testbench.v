`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] signal_a;
    reg [2:0] signal_b;
    reg [1:0] signal_c;
    reg signal_d;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal_a(signal_a),
        .signal_b(signal_b),
        .signal_c(signal_c),
        .signal_d(signal_d),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            signal_a = 4'b0000;
            signal_b = 3'b000;
            signal_c = 2'b00;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit in signal_a", test_num);
            signal_a = 4'b1000;
            signal_b = 3'b000;
            signal_c = 2'b00;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit in signal_b", test_num);
            signal_a = 4'b0000;
            signal_b = 3'b010;
            signal_c = 2'b00;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit in signal_c", test_num);
            signal_a = 4'b0000;
            signal_b = 3'b000;
            signal_c = 2'b01;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: signal_d high", test_num);
            signal_a = 4'b0000;
            signal_b = 3'b000;
            signal_c = 2'b00;
            signal_d = 1'b1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high", test_num);
            signal_a = 4'b1111;
            signal_b = 3'b111;
            signal_c = 2'b11;
            signal_d = 1'b1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed input - Odd Parity", test_num);
            signal_a = 4'b1101;
            signal_b = 3'b101;
            signal_c = 2'b11;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed input - Even Parity", test_num);
            signal_a = 4'b1011;
            signal_b = 3'b001;
            signal_c = 2'b10;
            signal_d = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern", test_num);
            signal_a = 4'b1010;
            signal_b = 3'b101;
            signal_c = 2'b10;
            signal_d = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundaries", test_num);
            signal_a = 4'b0001;
            signal_b = 3'b100;
            signal_c = 2'b10;
            signal_d = 1'b0;

            #1;


            check_outputs(1'b1);
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
        input expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
