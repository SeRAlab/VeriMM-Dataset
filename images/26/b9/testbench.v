`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
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
        .y1(y1),
        .y2(y2),
        .b(b),
        .m(m)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive slope through origin (y = 2x)", test_num);
            x1 = 8'd0;
            y1 = 8'd0;
            x2 = 8'd10;
            y2 = 8'd20;


            #1;



            check_outputs(16'h0000, 16'h0002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive slope with intercept (y = 5x + 5)", test_num);
            x1 = 8'd1;
            y1 = 8'd10;
            x2 = 8'd5;
            y2 = 8'd30;


            #1;



            check_outputs(16'h0005, 16'h0005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal line (y = 5)", test_num);
            x1 = 8'd2;
            y1 = 8'd5;
            x2 = 8'd6;
            y2 = 8'd5;


            #1;



            check_outputs(16'h0005, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Steeper slope (y = 10x + 0)", test_num);
            x1 = 8'd5;
            y1 = 8'd50;
            x2 = 8'd10;
            y2 = 8'd100;


            #1;



            check_outputs(16'h0000, 16'h000A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative slope (y = -5x + 75)", test_num);
            x1 = 8'd5;
            y1 = 8'd50;
            x2 = 8'd15;
            y2 = 8'd0;


            #1;



            check_outputs(16'h004B, 16'hFFFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Offset coordinates (y = 3x + 10)", test_num);
            x1 = 8'd20;
            y1 = 8'd70;
            x2 = 8'd30;
            y2 = 8'd100;


            #1;



            check_outputs(16'h000A, 16'h0003);
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
        testcase006();
        
        
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
