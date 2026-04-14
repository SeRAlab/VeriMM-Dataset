`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x0;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    reg [31:0] x4;
    reg [31:0] y0;
    reg [31:0] y1;
    reg [31:0] y2;
    reg [31:0] y3;
    reg [31:0] y4;
    wire [31:0] b;
    wire [31:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .b(b),
        .m(m)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Horizontal Line (y = 5)");

            x0 = 32'd1; x1 = 32'd2; x2 = 32'd3; x3 = 32'd4; x4 = 32'd5;
            y0 = 32'd5; y1 = 32'd5; y2 = 32'd5; y3 = 32'd5; y4 = 32'd5;


            #1;



            check_outputs(32'd5, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Identity Line (y = x)");

            x0 = 32'd1; x1 = 32'd2; x2 = 32'd3; x3 = 32'd4; x4 = 32'd5;
            y0 = 32'd1; y1 = 32'd2; y2 = 32'd3; y3 = 32'd4; y4 = 32'd5;


            #1;



            check_outputs(32'd0, 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Positive Slope and Intercept (y = 3x + 4)");

            x0 = 32'd1; x1 = 32'd2; x2 = 32'd3; x3 = 32'd4; x4 = 32'd5;
            y0 = 32'd7; y1 = 32'd10; y2 = 32'd13; y3 = 32'd16; y4 = 32'd19;



            #1;




            check_outputs(32'd4, 32'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Negative Slope (y = -2x + 10)");

            x0 = 32'd0; x1 = 32'd1; x2 = 32'd2; x3 = 32'd3; x4 = 32'd4;
            y0 = 32'd10; y1 = 32'd8; y2 = 32'd6; y3 = 32'd4; y4 = 32'd2;



            #1;




            check_outputs(32'd10, 32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Large Offset (y = x + 100)");

            x0 = 32'd1; x1 = 32'd2; x2 = 32'd3; x3 = 32'd4; x4 = 32'd5;
            y0 = 32'd101; y1 = 32'd102; y2 = 32'd103; y3 = 32'd104; y4 = 32'd105;

            #1;


            check_outputs(32'd100, 32'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_b;
        input [31:0] expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: b=%h, m=%h",
                         b, m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, m=%h",
                         expected_b, expected_m);
                $display("  Got:      b=%h, m=%h",
                         b, m);
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
