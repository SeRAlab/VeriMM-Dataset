`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CIN;
    reg [7:0] I0;
    reg [7:0] I1;
    wire [7:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CIN(CIN),
        .I0(I0),
        .I1(I1),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs, CIN=0", test_num);
            I0 = 8'h00;
            I1 = 8'h00;
            CIN = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs, CIN=1", test_num);
            I0 = 8'h00;
            I1 = 8'h00;
            CIN = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition, CIN=0", test_num);
            I0 = 8'h05;
            I1 = 8'h0A;
            CIN = 1'b0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition, CIN=1", test_num);
            I0 = 8'h05;
            I1 = 8'h0A;
            CIN = 1'b1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values causing overflow, CIN=0", test_num);
            I0 = 8'hFF;
            I1 = 8'h01;
            CIN = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values causing overflow, CIN=1", test_num);
            I0 = 8'hFF;
            I1 = 8'h01;
            CIN = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs 0xFF, CIN=0", test_num);
            I0 = 8'hFF;
            I1 = 8'hFF;
            CIN = 1'b0;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs 0xFF, CIN=1", test_num);
            I0 = 8'hFF;
            I1 = 8'hFF;
            CIN = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, CIN=0", test_num);
            I0 = 8'hAA;
            I1 = 8'h55;
            CIN = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, CIN=1", test_num);
            I0 = 8'hAA;
            I1 = 8'h55;
            CIN = 1'b1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
