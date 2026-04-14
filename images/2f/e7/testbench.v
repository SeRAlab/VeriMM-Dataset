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
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Line y = 10", test_num);
            x0 = 32'd0; y0 = 32'd10;
            x1 = 32'd1; y1 = 32'd10;
            x2 = 32'd2; y2 = 32'd10;
            x3 = 32'd3; y3 = 32'd10;
            x4 = 32'd4; y4 = 32'd10;
            #1;

            check_outputs(32'd10, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Line y = x", test_num);
            x0 = 32'd0; y0 = 32'd0;
            x1 = 32'd1; y1 = 32'd1;
            x2 = 32'd2; y2 = 32'd2;
            x3 = 32'd3; y3 = 32'd3;
            x4 = 32'd4; y4 = 32'd4;
            #1;

            check_outputs(32'd0, 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Line y = 2x + 5", test_num);
            x0 = 32'd0; y0 = 32'd5;
            x1 = 32'd1; y1 = 32'd7;
            x2 = 32'd2; y2 = 32'd9;
            x3 = 32'd3; y3 = 32'd11;
            x4 = 32'd4; y4 = 32'd13;
            #1;

            check_outputs(32'd5, 32'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Slope y = -2x + 20", test_num);
            x0 = 32'd0; y0 = 32'd20;
            x1 = 32'd1; y1 = 32'd18;
            x2 = 32'd2; y2 = 32'd16;
            x3 = 32'd3; y3 = 32'd14;
            x4 = 32'd4; y4 = 32'd12;
            #1;

            check_outputs(32'd20, 32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Offset X coordinates y = x + 10", test_num);
            x0 = 32'd10; y0 = 32'd20;
            x1 = 32'd11; y1 = 32'd21;
            x2 = 32'd12; y2 = 32'd22;
            x3 = 32'd13; y3 = 32'd23;
            x4 = 32'd14; y4 = 32'd24;
            #1;

            check_outputs(32'd10, 32'd1);
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
