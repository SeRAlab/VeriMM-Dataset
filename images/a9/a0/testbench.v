`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] posit;
    reg [6:0] shift_onehot;
    wire [4:0] expfrac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .posit(posit),
        .shift_onehot(shift_onehot),
        .expfrac(expfrac)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 0 (one-hot), posit pattern A", test_num);
            posit = 8'b0_0_101010;
            shift_onehot = 7'b0000001;

            #1;


            check_outputs(5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 1 (one-hot), posit pattern B", test_num);
            posit = 8'b0_00_11011;
            shift_onehot = 7'b0000010;

            #1;


            check_outputs(5'b10110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 2 (one-hot), posit pattern C", test_num);
            posit = 8'b0_000_1111;
            shift_onehot = 7'b0000100;

            #1;


            check_outputs(5'b11100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 3 (one-hot), posit pattern D", test_num);
            posit = 8'b1_0000_101;
            shift_onehot = 7'b0001000;

            #1;


            check_outputs(5'b01000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 4 (one-hot), posit pattern E", test_num);
            posit = 8'b1_11111_0_1;
            shift_onehot = 7'b0010000;

            #1;


            check_outputs(5'b10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 5 (one-hot)", test_num);
            posit = 8'b01111111;
            shift_onehot = 7'b0100000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Posit All Ones, Shift bit 0", test_num);
            posit = 8'b11111111;
            shift_onehot = 7'b0000001;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Posit All Zeros, Shift bit 0", test_num);
            posit = 8'b00000000;
            shift_onehot = 7'b0000001;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift bit 6 (one-hot)", test_num);
            posit = 8'b10101010;
            shift_onehot = 7'b1000000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Posit, Shift bit 1", test_num);
            posit = 8'hAA;
            shift_onehot = 7'b0000010;

            #1;


            check_outputs(5'b01010);
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
        input [4:0] expected_expfrac;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_expfrac === (expected_expfrac ^ expfrac ^ expected_expfrac)) begin
                $display("PASS");
                $display("  Outputs: expfrac=%h",
                         expfrac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expfrac=%h",
                         expected_expfrac);
                $display("  Got:      expfrac=%h",
                         expfrac);
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
