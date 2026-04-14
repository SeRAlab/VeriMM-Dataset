`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [35:0] x;
    wire [17:0] cout;
    wire s2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .cout(cout),
        .s2(s2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            x = 36'h0;
            #1;

            check_outputs(18'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower input 1, upper 0", test_num);
            x = {18'h0, 18'h1};
            #1;

            check_outputs(18'h1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper input 1, lower 0", test_num);
            x = {18'h1, 18'h0};
            #1;

            check_outputs(18'h1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum value without carry out", test_num);
            x = {18'h1FFFF, 18'h1FFFF};
            #1;

            check_outputs(18'h3FFFE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out generated (exact 19th bit)", test_num);
            x = {18'h20000, 18'h20000};
            #1;

            check_outputs(18'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max carry out case", test_num);
            x = {18'h3FFFF, 18'h3FFFF};
            #1;

            check_outputs(18'h3FFFE, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry out from partial sum", test_num);
            x = {18'h3FFFF, 18'h00001};
            #1;

            check_outputs(18'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary values", test_num);
            x = {18'h12345, 18'h0AAAA};
            #1;

            check_outputs(18'h1CDEF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary values with carry", test_num);
            x = {18'h2ABCD, 18'h15433};

            #1;


            check_outputs(18'h0, 1'b1);
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
        input [17:0] expected_cout;
        input expected_s2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s2=%b",
                         cout, s2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s2=%b",
                         expected_cout, expected_s2);
                $display("  Got:      cout=%h, s2=%b",
                         cout, s2);
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
