`timescale 1ns/1ps

module square_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num;
    wire [7:0] square;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    square_module dut (
        .num(num),
        .square(square)
    );
    task testcase001;

        begin
            test_num = 1;
            num = 4'd0;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            num = 4'd1;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            num = 4'd2;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            num = 4'd3;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            num = 4'd4;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            num = 4'd5;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            num = 4'd6;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd36);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            num = 4'd7;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd49);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            num = 4'd8;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            num = 4'd9;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd81);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            num = 4'd10;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            num = 4'd11;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd121);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            num = 4'd12;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            num = 4'd13;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd169);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            num = 4'd14;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd196);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            num = 4'd15;
            $display("Test Case %0d: num = %d", test_num, num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("square_module Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_square;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_square === (expected_square ^ square ^ expected_square)) begin
                $display("PASS");
                $display("  Outputs: square=%h",
                         square);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: square=%h",
                         expected_square);
                $display("  Got:      square=%h",
                         square);
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
