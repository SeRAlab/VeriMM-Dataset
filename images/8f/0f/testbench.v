`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input 8'h00 (All Zeros)", test_num);
        x = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input 8'hFF (All Ones)", test_num);
        x = 8'hFF;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input 8'h01 (LSB set)", test_num);
        x = 8'h01;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input 8'h80 (MSB set)", test_num);
        x = 8'h80;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input 8'h55 (Alternating bits)", test_num);
        x = 8'h55;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input 8'hAA (Alternating bits)", test_num);
        x = 8'hAA;
        #1;

        check_outputs(8'h54);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input 8'h0F (Lower nibble)", test_num);
        x = 8'h0F;
        #1;

        check_outputs(8'h1E);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input 8'hC3", test_num);
        x = 8'hC3;
        #1;

        check_outputs(8'h86);
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
        input [7:0] expected_out;
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
