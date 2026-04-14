`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] A;
    reg [9:0] B;
    reg sel;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select A (All Ones vs All Zeros)", test_num);
            A = 10'h3FF;
            B = 10'h000;
            sel = 1'b0;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select B (All Ones vs All Zeros)", test_num);
            A = 10'h3FF;
            B = 10'h000;
            sel = 1'b1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select A (Alternating Bit Patterns)", test_num);
            A = 10'h155;
            B = 10'h2AA;
            sel = 1'b0;
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select B (Alternating Bit Patterns)", test_num);
            A = 10'h155;
            B = 10'h2AA;
            sel = 1'b1;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select A (Random Hex Values)", test_num);
            A = 10'h249;
            B = 10'h1B6;
            sel = 1'b0;
            #1;

            check_outputs(10'h249);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select B (Random Hex Values)", test_num);
            A = 10'h249;
            B = 10'h1B6;
            sel = 1'b1;
            #1;

            check_outputs(10'h1B6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Toggle sel with same inputs", test_num);
            A = 10'h123;
            B = 10'h123;
            sel = 1'b0;
            #1;

            check_outputs(10'h123);
            sel = 1'b1;
            #1;

            check_outputs(10'h123);
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
        input [9:0] expected_out;
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
