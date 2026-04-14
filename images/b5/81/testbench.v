`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_0;
    wire c_4;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_0(c_0),
        .c_4(c_4),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'b0000; b = 4'b0000; c_0 = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'b0000; b = 4'b0000; c_0 = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd5; b = 4'd3; c_0 = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd10; b = 4'd5; c_0 = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd15; b = 4'd0; c_0 = 1'b1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b1111; b = 4'b0000; c_0 = 1'b1;
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd15; b = 4'd15; c_0 = 1'b1;
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'b0100; b = 4'b0100; c_0 = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'b1010; b = 4'b0101; c_0 = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd8; b = 4'd8; c_0 = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
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
        input expected_c_4;
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_4 === (expected_c_4 ^ c_4 ^ expected_c_4) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c_4=%b, s=%h",
                         c_4, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_4=%b, s=%h",
                         expected_c_4, expected_s);
                $display("  Got:      c_4=%b, s=%h",
                         c_4, s);
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
