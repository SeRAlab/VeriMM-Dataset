`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [1:0] signal;
    wire [31:0] selected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .signal(signal),
        .selected(selected)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select A (signal=00)", test_num);
            A = 32'hDEADBEEF;
            B = 32'h00000000;
            C = 32'hFFFFFFFF;
            signal = 2'b00;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select B (signal=01)", test_num);
            A = 32'h11111111;
            B = 32'h22222222;
            C = 32'h33333333;
            signal = 2'b01;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select C (signal=10)", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            C = 32'h12345678;
            signal = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select A with all zeros", test_num);
            A = 32'h00000000;
            B = 32'hFFFFFFFF;
            C = 32'hABCDEF01;
            signal = 2'b00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select B with all ones", test_num);
            A = 32'h12344321;
            B = 32'hFFFFFFFF;
            C = 32'h00000000;
            signal = 2'b01;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select C with alternating bits", test_num);
            A = 32'h0;
            B = 32'h0;
            C = 32'hA5A5A5A5;
            signal = 2'b10;
            #1;

            check_outputs(32'hA5A5A5A5);
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
        input [31:0] expected_selected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selected === (expected_selected ^ selected ^ expected_selected)) begin
                $display("PASS");
                $display("  Outputs: selected=%h",
                         selected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected=%h",
                         expected_selected);
                $display("  Got:      selected=%h",
                         selected);
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
