`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_in;
    reg [15:0] b_in;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select input A (sel=0)", test_num);
        sel = 1'b0;
        a_in = 16'hAAAA;
        b_in = 16'h5555;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select input B (sel=1)", test_num);
        sel = 1'b1;
        a_in = 16'hAAAA;
        b_in = 16'h5555;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: All ones on A, zeros on B, Select A", test_num);
        sel = 1'b0;
        a_in = 16'hFFFF;
        b_in = 16'h0000;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All ones on A, zeros on B, Select B", test_num);
        sel = 1'b1;
        a_in = 16'hFFFF;
        b_in = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Boundary value 16'h0001 vs 16'h8000, Select A", test_num);
        sel = 1'b0;
        a_in = 16'h0001;
        b_in = 16'h8000;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Boundary value 16'h0001 vs 16'h8000, Select B", test_num);
        sel = 1'b1;
        a_in = 16'h0001;
        b_in = 16'h8000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Random pattern, Select A", test_num);
        sel = 1'b0;
        a_in = 16'h1234;
        b_in = 16'hABCD;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Random pattern, Select B", test_num);
        sel = 1'b1;
        a_in = 16'h1234;
        b_in = 16'hABCD;
        #1;

        check_outputs(16'hABCD);
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
