`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg cin;
    wire cout;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0005; b = 16'h000A; cin = 0;
            #1;

            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h0064; b = 16'h00C8; cin = 1;
            #1;

            check_outputs(1'b0, 16'h012D);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'hFFFF; b = 16'h0001; cin = 0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'sd1000; b = 16'sd2000; cin = 0;
            #1;

            check_outputs(1'b0, 16'sd3000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = -16'sd5; b = -16'sd10; cin = 0;
            #1;

            check_outputs(1'b1, -16'sd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h7FFF; b = 16'h0001; cin = 0;
            #1;

            check_outputs(1'b0, 16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'h8000; b = 16'hFFFF; cin = 0;
            #1;

            check_outputs(1'b1, 16'h7FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'sd1234; b = -16'sd1234; cin = 0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'hFFFF; b = 16'hFFFF; cin = 1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'h0000; b = 16'h0000; cin = 1;
            #1;

            check_outputs(1'b0, 16'h0001);
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
        input expected_cout;
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
