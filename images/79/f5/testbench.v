`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] a;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 7'b0000000;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 7'b1111111;
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 7'b1000000;
        #1;

        check_outputs(7'b0100000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 7'b0000001;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 7'b0000010;
        #1;

        check_outputs(7'b0000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 7'b1010101;
        #1;

        check_outputs(7'b0101010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 7'b0101010;
        #1;

        check_outputs(7'b0010101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 7'b0111100;
        #1;

        check_outputs(7'b0011110);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 7'b1100110;
        #1;

        check_outputs(7'b0110011);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 7'b1001001;
        #1;

        check_outputs(7'b0100100);
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
        input [6:0] expected_out;
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
