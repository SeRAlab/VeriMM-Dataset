`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd0;
        B = 4'd0;
        $display("Test %0d: 0 * 0", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd10;
        B = 4'd0;
        $display("Test %0d: 10 * 0", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd0;
        B = 4'd15;
        $display("Test %0d: 0 * 15", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd1;
        B = 4'd1;
        $display("Test %0d: 1 * 1", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd15;
        B = 4'd1;
        $display("Test %0d: 15 * 1", test_num);
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd3;
        B = 4'd4;
        $display("Test %0d: 3 * 4", test_num);
        #1;

        check_outputs(8'd12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd15;
        B = 4'd15;
        $display("Test %0d: 15 * 15 (Max Value)", test_num);
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'd10;
        B = 4'd5;
        $display("Test %0d: 10 * 5", test_num);
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'd7;
        B = 4'd8;
        $display("Test %0d: 7 * 8", test_num);
        #1;

        check_outputs(8'd56);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd13;
        B = 4'd11;
        $display("Test %0d: 13 * 11", test_num);
        #1;

        check_outputs(8'd143);
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
        input [7:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
