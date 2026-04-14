`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero product (0 * 0)", test_num);
        A = 8'd0;
        B = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Zero product (255 * 0)", test_num);
        A = 8'd255;
        B = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Identity (1 * 128)", test_num);
        A = 8'd1;
        B = 8'd128;
        #1;

        check_outputs(16'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Small values (5 * 10)", test_num);
        A = 8'd5;
        B = 8'd10;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Mid-range values (15 * 15)", test_num);
        A = 8'd15;
        B = 8'd15;
        #1;

        check_outputs(16'd225);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Power of 2 (16 * 16)", test_num);
        A = 8'd16;
        B = 8'd16;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Large values (100 * 200)", test_num);
        A = 8'd100;
        B = 8'd200;
        #1;

        check_outputs(16'd20000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Maximum values (255 * 255)", test_num);
        A = 8'hFF;
        B = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Alternating bits (0xAA * 0x55)", test_num);
        A = 8'hAA;
        B = 8'h55;
        #1;

        check_outputs(16'd14450);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Prime numbers (13 * 17)", test_num);
        A = 8'd13;
        B = 8'd17;
        #1;

        check_outputs(16'd221);
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
        input [15:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
