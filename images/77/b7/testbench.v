`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] shift_amt;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift_amt(shift_amt),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero shift", test_num);
            in = 16'hABCD;
            shift_amt = 4'd0;

            #1;


            check_outputs(8'hAB, 8'hCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 1", test_num);
            in = 16'hFFFF;
            shift_amt = 4'd1;

            #1;


            check_outputs(8'hFF, 8'hFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 4", test_num);
            in = 16'h1234;
            shift_amt = 4'd4;

            #1;


            check_outputs(8'h23, 8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 8", test_num);
            in = 16'h00FF;
            shift_amt = 4'd8;

            #1;


            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 12", test_num);
            in = 16'h000F;
            shift_amt = 4'd12;

            #1;


            check_outputs(8'hF0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 15", test_num);
            in = 16'h0001;
            shift_amt = 4'd15;

            #1;


            check_outputs(8'h80, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pattern shift", test_num);
            in = 16'hAAAA;
            shift_amt = 4'd2;

            #1;


            check_outputs(8'hAA, 8'hA8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones mid-shift", test_num);
            in = 16'hFFFF;
            shift_amt = 4'd6;

            #1;


            check_outputs(8'hFF, 8'hC0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shifting bits out of range", test_num);
            in = 16'hF000;
            shift_amt = 4'd4;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary crossing shift", test_num);
            in = 16'h0F0F;
            shift_amt = 4'd4;

            #1;


            check_outputs(8'hF0, 8'hF0);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h",
                         expected_out_hi, expected_out_lo);
                $display("  Got:      out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
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
