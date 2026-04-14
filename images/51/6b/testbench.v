`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] y1;
    wire [3:0] y2;
    wire [3:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=1, b=2 (Basic Operation)", test_num);
            a = 4'd1;
            b = 4'd2;



            #1;




            check_outputs(4'hF, 4'h3, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=3, b=3 (a == b Equality)", test_num);
            a = 4'd3;
            b = 4'd3;



            #1;




            check_outputs(4'hD, 4'h6, 4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=0, b=0 (Zero Case)", test_num);
            a = 4'd0;
            b = 4'd0;



            #1;




            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=8, b=0 (Max Negative 2's Complement)", test_num);
            a = 4'b1000;
            b = 4'd0;



            #1;




            check_outputs(4'h8, 4'h8, 4'h8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=15, b=1 (Overflow/Wrap-around)", test_num);
            a = 4'hF;
            b = 4'h1;



            #1;




            check_outputs(4'h1, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=7, b=7 (a == b boundary)", test_num);
            a = 4'd7;
            b = 4'd7;



            #1;




            check_outputs(4'h9, 4'hE, 4'h9);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a=5, b=10 (Mismatch)", test_num);
            a = 4'd5;
            b = 4'd10;



            #1;




            check_outputs(4'hB, 4'hF, 4'hF);
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
        input [3:0] expected_y1;
        input [3:0] expected_y2;
        input [3:0] expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y1=%h, y2=%h, y3=%h",
                         y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%h, y2=%h, y3=%h",
                         expected_y1, expected_y2, expected_y3);
                $display("  Got:      y1=%h, y2=%h, y3=%h",
                         y1, y2, y3);
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
