`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [1:0] shift;
    wire [15:0] sout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift(shift),
        .sout(sout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through (shift=00)", test_num);
            in = 16'hABCD;
            shift = 2'b00;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Shift Left (shift=01) - General", test_num);
            in = 16'h1234;
            shift = 2'b01;
            #1;

            check_outputs(16'h2468);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Shift Left (shift=01) - Shift out MSB", test_num);
            in = 16'h8001;
            shift = 2'b01;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Shift Right (shift=10) - General", test_num);
            in = 16'h4321;
            shift = 2'b10;
            #1;

            check_outputs(16'h2190);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Shift Right (shift=10) - Shift out LSB", test_num);
            in = 16'h8001;
            shift = 2'b10;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Shift Right (shift=11) - Negative Number", test_num);
            in = 16'h8000;
            shift = 2'b11;
            #1;

            check_outputs(16'hC000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Shift Right (shift=11) - Positive Number", test_num);
            in = 16'h7000;
            shift = 2'b11;
            #1;

            check_outputs(16'h3800);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Shift Right (shift=11) - All Ones", test_num);
            in = 16'hFFFF;
            shift = 2'b11;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through (shift=00) - Zero", test_num);
            in = 16'h0000;
            shift = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Shift Left (shift=01) - Max Value", test_num);
            in = 16'hFFFF;
            shift = 2'b01;
            #1;

            check_outputs(16'hFFFE);
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
        input [15:0] expected_sout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sout === (expected_sout ^ sout ^ expected_sout)) begin
                $display("PASS");
                $display("  Outputs: sout=%h",
                         sout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sout=%h",
                         expected_sout);
                $display("  Got:      sout=%h",
                         sout);
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
