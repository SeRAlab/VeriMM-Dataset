`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] shift;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Shift by 0 (Identity)", test_num);
            in = 16'hABCD;
            shift = 4'd0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift by 1", test_num);
            in = 16'h0001;
            shift = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift all ones by 4", test_num);
            in = 16'hFFFF;
            shift = 4'd4;
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift by 8", test_num);
            in = 16'h00FF;
            shift = 4'd8;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift by 15 (Max shift range)", test_num);
            in = 16'h0001;
            shift = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shifting MSB out of bounds", test_num);
            in = 16'h8000;
            shift = 4'd1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Complex bit pattern shift", test_num);
            in = 16'h1234;
            shift = 4'd2;
            #1;

            check_outputs(16'h48D0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Zero input shift", test_num);
            in = 16'h0000;
            shift = 4'd10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Alternating bits shift", test_num);
            in = 16'hAAAA;
            shift = 4'd1;
            #1;

            check_outputs(16'h5554);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Shift by 12", test_num);
            in = 16'h000F;
            shift = 4'd12;
            #1;

            check_outputs(16'hF000);
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
        input [15:0] expected_out;
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
