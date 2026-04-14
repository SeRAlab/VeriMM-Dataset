`timescale 1ns/1ps

module simple_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: a < b (a=2, b=5, c=2) -> y = a << c", test_num);
        a = 4'd2; b = 4'd5; c = 4'd2;
        #1;

        check_outputs(9'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: a > b (a=10, b=3, c=3) -> y = b << c", test_num);
        a = 4'd10; b = 4'd3; c = 4'd3;
        #1;

        check_outputs(9'd24);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: a == b (a=7, b=7, c=15) -> y = a & b", test_num);
        a = 4'd7; b = 4'd7; c = 4'd15;
        #1;

        check_outputs(9'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: a < b, Max 9-bit result (a=1, b=2, c=8)", test_num);
        a = 4'd1; b = 4'd2; c = 4'd8;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: a > b, Shift result 0 (a=15, b=0, c=4)", test_num);
        a = 4'd15; b = 4'd0; c = 4'd4;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: a < b, Overshift (a=1, b=2, c=9)", test_num);
        a = 4'd1; b = 4'd2; c = 4'd9;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: a == b, Zero check (a=0, b=0, c=0)", test_num);
        a = 4'd0; b = 4'd0; c = 4'd0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: a == b, Max 4-bit AND (a=15, b=15, c=1)", test_num);
        a = 4'd15; b = 4'd15; c = 4'd1;
        #1;

        check_outputs(9'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: a < b, Shift by 0 (a=12, b=13, c=0)", test_num);
        a = 4'd12; b = 4'd13; c = 4'd0;
        #1;

        check_outputs(9'd12);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: a > b, Shift by 1 (a=5, b=4, c=1)", test_num);
        a = 4'd5; b = 4'd4; c = 4'd1;
        #1;

        check_outputs(9'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple Testbench");
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
        input [8:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
