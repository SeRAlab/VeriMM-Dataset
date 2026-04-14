`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    wire Valid;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Valid(Valid),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'b0000_0000;
            #5;
            $display("Testcase %03d: Input 00000000 (Expect Valid=0)", test_num);



            #1;




            check_outputs(1'b0, Y);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'b0000_0001;
            #5;
            $display("Testcase %03d: Input 00000001 (Expect Y=0, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'b0000_0010;
            #5;
            $display("Testcase %03d: Input 00000010 (Expect Y=1, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'b0000_0100;
            #5;
            $display("Testcase %03d: Input 00000100 (Expect Y=2, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'b0000_1000;
            #5;
            $display("Testcase %03d: Input 00001000 (Expect Y=3, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'b0001_0000;
            #5;
            $display("Testcase %03d: Input 00010000 (Expect Y=4, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'b0010_0000;
            #5;
            $display("Testcase %03d: Input 00100000 (Expect Y=5, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'b0100_0000;
            #5;
            $display("Testcase %03d: Input 01000000 (Expect Y=6, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'b1000_0000;
            #5;
            $display("Testcase %03d: Input 10000000 (Expect Y=7, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'b1010_1011;
            #5;
            $display("Testcase %03d: Input 10101011 (Expect Y=7, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd7);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 8'b0001_1111;
            #5;
            $display("Testcase %03d: Input 00011111 (Expect Y=4, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            A = 8'b1111_1111;
            #5;
            $display("Testcase %03d: Input 11111111 (Expect Y=7, Valid=1)", test_num);
            #1;

            check_outputs(1'b1, 3'd7);
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
        testcase011();
        testcase012();
        
        
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
        input expected_Valid;
        input [2:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Valid === (expected_Valid ^ Valid ^ expected_Valid) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Valid=%b, Y=%h",
                         Valid, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Valid=%b, Y=%h",
                         expected_Valid, expected_Y);
                $display("  Got:      Valid=%b, Y=%h",
                         Valid, Y);
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
