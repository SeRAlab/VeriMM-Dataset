`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire [15:0] b;
    wire [15:0] m;
    wire valid;

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
        .m(m),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive slope and intercept", test_num);
            x1 = 16'd2; y1 = 16'd5;
            x2 = 16'd4; y2 = 16'd9;
            #1;

            check_outputs(16'd1, 16'd2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertical line (x1 == x2)", test_num);
            x1 = 16'd5; y1 = 16'd2;
            x2 = 16'd5; y2 = 16'd8;


            #1;



            check_outputs(b, m, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative slope", test_num);
            x1 = 16'd1; y1 = 16'd10;
            x2 = 16'd3; y2 = 16'd4;
            #1;

            check_outputs(16'h000D, 16'hFFFD, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal line (y1 == y2)", test_num);
            x1 = 16'd1; y1 = 16'd5;
            x2 = 16'd6; y2 = 16'd5;
            #1;

            check_outputs(16'd5, 16'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Line through origin (m=1, b=0)", test_num);
            x1 = 16'd0; y1 = 16'd0;
            x2 = 16'd10; y2 = 16'd10;
            #1;

            check_outputs(16'd0, 16'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large slope and offset", test_num);
            x1 = 16'd0; y1 = 16'd100;
            x2 = 16'd1; y2 = 16'd250;
            #1;

            check_outputs(16'd100, 16'd150, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identical points", test_num);
            x1 = 16'd7; y1 = 16'd7;
            x2 = 16'd7; y2 = 16'd7;
            #1;

            check_outputs(b, m, 1'b0);
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
        testcase007();
        
        
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_m === (expected_m ^ m ^ expected_m) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: b=%h, m=%h, valid=%b",
                         b, m, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, m=%h, valid=%b",
                         expected_b, expected_m, expected_valid);
                $display("  Got:      b=%h, m=%h, valid=%b",
                         b, m, valid);
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
