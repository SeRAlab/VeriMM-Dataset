`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [8:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All bits zero", test_num);
            in = 8'b00000000;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single bit set", test_num);
            in = 8'b00000001;
            #1;

            check_outputs(9'h101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Two bits set (Even parity)", test_num);
            in = 8'b00000011;
            #1;

            check_outputs(9'h003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Three bits set (Odd parity)", test_num);
            in = 8'b00000111;
            #1;

            check_outputs(9'h107);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All bits set (8 bits = Even)", test_num);
            in = 8'hFF;
            #1;

            check_outputs(9'h0FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating bits AA", test_num);
            in = 8'hAA;
            #1;

            check_outputs(9'h0AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating bits 55", test_num);
            in = 8'h55;
            #1;

            check_outputs(9'h055);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Most significant bit only", test_num);
            in = 8'h80;
            #1;

            check_outputs(9'h180);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Seven bits set", test_num);
            in = 8'hFE;
            #1;

            check_outputs(9'h1FE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random pattern 0x12", test_num);
            in = 8'h12;
            #1;

            check_outputs(9'h012);
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
        input [8:0] expected_out;
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
