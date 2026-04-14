`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] int_s1;
    reg [6:0] x;
    wire [4:0] cout;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .int_s1(int_s1),
        .x(x),
        .cout(cout),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 7'b0000000; int_s1 = 3'b000;
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 7'b1111111; int_s1 = 3'b111;
            #1;

            check_outputs(5'd31, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 7'h3E; int_s1 = 3'b000;
            #1;

            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 7'b0000000; int_s1 = 3'b001;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 7'h7C; int_s1 = 3'b001;
            #1;

            check_outputs(5'd16, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 7'h29; int_s1 = 3'd2;
            #1;

            check_outputs(5'd10, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 7'h03; int_s1 = 3'd7;
            #1;

            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 7'h7C; int_s1 = 3'd0;
            #1;

            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            x = 7'h55; int_s1 = 3'd2;
            #1;

            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            x = 7'h40; int_s1 = 3'd0;
            #1;

            check_outputs(5'd8, 1'b0);
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
        input [4:0] expected_cout;
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s=%b",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s=%b",
                         expected_cout, expected_s);
                $display("  Got:      cout=%h, s=%b",
                         cout, s);
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
