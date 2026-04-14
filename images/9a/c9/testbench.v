`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] mode;
    wire overflow;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mode(mode),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'd10; b = 8'd5; mode = 2'b00;
        $display("Test %0d: Unsigned 10 * 5", test_num);
        #1;

        check_outputs(1'b0, 16'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'd255; b = 8'd2; mode = 2'b00;
        $display("Test %0d: Unsigned 255 * 2 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 16'd510);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'sd10; b = 8'sd5; mode = 2'b01;
        $display("Test %0d: Signed 10 * 5", test_num);
        #1;

        check_outputs(1'b0, 16'h0032);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = -8'sd10; b = 8'sd5; mode = 2'b01;
        $display("Test %0d: Signed -10 * 5", test_num);
        #1;

        check_outputs(1'b0, 16'hFFCE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = -8'sd12; b = -8'sd10; mode = 2'b01;
        $display("Test %0d: Signed -12 * -10", test_num);
        #1;

        check_outputs(1'b0, 16'd120);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'sd20; b = 8'sd10; mode = 2'b01;
        $display("Test %0d: Signed 20 * 10 (Overflow > 127)", test_num);
        #1;

        check_outputs(1'b1, 16'd200);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'd200; b = -8'sd2; mode = 2'b10;
        $display("Test %0d: Unsigned 200 * Signed -2", test_num);
        #1;

        check_outputs(1'b1, 16'hFE70);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'd10; b = -8'sd5; mode = 2'b10;
        $display("Test %0d: Unsigned 10 * Signed -5", test_num);
        #1;

        check_outputs(1'b0, 16'hFFCE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = -8'sd2; b = 8'd200; mode = 2'b11;
        $display("Test %0d: Signed -2 * Unsigned 200", test_num);
        #1;

        check_outputs(1'b1, 16'hFE70);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 8'h80; b = 8'h80; mode = 2'b01;
        $display("Test %0d: Signed -128 * -128", test_num);
        #1;

        check_outputs(1'b1, 16'h4000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 8'hFF; b = 8'hFF; mode = 2'b00;
        $display("Test %0d: Unsigned 255 * 255", test_num);
        #1;

        check_outputs(1'b1, 16'hFE01);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 8'd0; b = 8'hFF; mode = 2'b00;
        $display("Test %0d: Zero multiplication", test_num);
        #1;

        check_outputs(1'b0, 16'h0000);
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
        input expected_overflow;
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
