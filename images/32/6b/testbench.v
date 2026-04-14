`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    reg [15:0] x4;
    reg [15:0] x5;
    reg [15:0] y1;
    reg [15:0] y2;
    reg [15:0] y3;
    reg [15:0] y4;
    reg [15:0] y5;
    wire [15:0] b;
    wire [15:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .y5(y5),
        .b(b),
        .m(m)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: y = x", test_num);
            x1 = 16'd1; y1 = 16'd1;
            x2 = 16'd2; y2 = 16'd2;
            x3 = 16'd3; y3 = 16'd3;
            x4 = 16'd4; y4 = 16'd4;
            x5 = 16'd5; y5 = 16'd5;
            #1;

            check_outputs(16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: y = 2x + 5", test_num);
            x1 = 16'd1; y1 = 16'd7;
            x2 = 16'd2; y2 = 16'd9;
            x3 = 16'd3; y3 = 16'd11;
            x4 = 16'd4; y4 = 16'd13;
            x5 = 16'd5; y5 = 16'd15;
            #1;

            check_outputs(16'h0005, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal line y = 10", test_num);
            x1 = 16'd1; y1 = 16'd10;
            x2 = 16'd2; y2 = 16'd10;
            x3 = 16'd3; y3 = 16'd10;
            x4 = 16'd4; y4 = 16'd10;
            x5 = 16'd5; y5 = 16'd10;
            #1;

            check_outputs(16'h000A, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative slope y = -3x + 20", test_num);
            x1 = 16'd1; y1 = 16'd17;
            x2 = 16'd2; y2 = 16'd14;
            x3 = 16'd3; y3 = 16'd11;
            x4 = 16'd4; y4 = 16'd8;
            x5 = 16'd5; y5 = 16'd5;
            #1;

            check_outputs(16'h0014, 16'hFFFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: y = 5x + 100", test_num);
            x1 = 16'd10; y1 = 16'd150;
            x2 = 16'd20; y2 = 16'd200;
            x3 = 16'd30; y3 = 16'd250;
            x4 = 16'd40; y4 = 16'd300;
            x5 = 16'd50; y5 = 16'd350;
            #1;

            check_outputs(16'h0064, 16'h0005);
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
        input [15:0] expected_b;
        input [15:0] expected_m;
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
