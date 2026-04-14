`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .r(r)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: 0 * 0", test_num);
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: 255 * 0", test_num);
            a = 8'd255;
            b = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: 0 * 255", test_num);
            a = 8'd0;
            b = 8'd255;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: 1 * 1", test_num);
            a = 8'd1;
            b = 8'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: 255 * 1", test_num);
            a = 8'd255;
            b = 8'd1;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: 16 * 16", test_num);
            a = 8'd16;
            b = 8'd16;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: 123 * 45", test_num);
            a = 8'd123;
            b = 8'd45;
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: 255 * 255 (Max values)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: 128 * 2", test_num);
            a = 8'd128;
            b = 8'd2;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: 15 * 15", test_num);
            a = 8'd15;
            b = 8'd15;
            #1;

            check_outputs(16'd225);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: 170 * 85 (Alternating bits)", test_num);
            a = 8'b10101010;
            b = 8'b01010101;
            #1;

            check_outputs(16'd14450);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: 64 * 4", test_num);
            a = 8'd64;
            b = 8'd4;
            #1;

            check_outputs(16'd256);
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
        input [15:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
