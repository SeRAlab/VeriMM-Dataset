`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] h;
    wire [2:0] out_and;
    wire [3:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .out_and(out_and),
        .out_xor(out_xor)
    );
    task testcase001;

    begin
        test_num = 1;
        h = 4'b0000;
        #1;

        check_outputs(3'b000, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        h = 4'b1111;
        #1;

        check_outputs(3'b111, 4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        h = 4'b1010;
        #1;

        check_outputs(3'b000, 4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        h = 4'b0101;
        #1;

        check_outputs(3'b000, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        h = 4'b0001;
        #1;

        check_outputs(3'b000, 4'b1001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        h = 4'b0011;
        #1;

        check_outputs(3'b001, 4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        h = 4'b0111;
        #1;

        check_outputs(3'b011, 4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        h = 4'b1000;
        #1;

        check_outputs(3'b000, 4'b1100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        h = 4'b1100;
        #1;

        check_outputs(3'b100, 4'b1010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        h = 4'b1001;
        #1;

        check_outputs(3'b000, 4'b0101);
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
        input [2:0] expected_out_and;
        input [3:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_xor=%h",
                         out_and, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_xor=%h",
                         expected_out_and, expected_out_xor);
                $display("  Got:      out_and=%h, out_xor=%h",
                         out_and, out_xor);
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
