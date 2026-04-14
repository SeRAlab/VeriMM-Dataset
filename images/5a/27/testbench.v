`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_1;
    reg [31:0] input_2;
    reg sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            input_1 = 32'hDEADBEEF;
            input_2 = 32'hCAFEBABE;
            sel = 0;
            $display("Test %0d: Selecting input_1 (sel=0)", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input_1 = 32'hDEADBEEF;
            input_2 = 32'hCAFEBABE;
            sel = 1;
            $display("Test %0d: Selecting input_2 (sel=1)", test_num);
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input_1 = 32'hFFFFFFFF;
            input_2 = 32'h00000000;
            sel = 0;
            $display("Test %0d: Boundary check - all ones vs all zeros (sel=0)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input_1 = 32'hFFFFFFFF;
            input_2 = 32'h00000000;
            sel = 1;
            $display("Test %0d: Boundary check - all ones vs all zeros (sel=1)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input_1 = 32'hAAAAAAAA;
            input_2 = 32'h55555555;
            sel = 0;
            $display("Test %0d: Alternating bit patterns (sel=0)", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input_1 = 32'hAAAAAAAA;
            input_2 = 32'h55555555;
            sel = 1;
            $display("Test %0d: Alternating bit patterns (sel=1)", test_num);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input_1 = 32'h12345678;
            input_2 = 32'h87654321;
            sel = 0;
            $display("Test %0d: Random selection 1 (sel=0)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input_1 = 32'h12345678;
            input_2 = 32'h87654321;
            sel = 1;
            $display("Test %0d: Random selection 2 (sel=1)", test_num);
            #1;

            check_outputs(32'h87654321);
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
        input [31:0] expected_out;
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
