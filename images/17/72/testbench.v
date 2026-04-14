`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire [31:0] b;
    wire [31:0] m;

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
            $display("Test %0d: Simple positive slope (m=2, b=0)", test_num);
            x1 = 16'd1; y1 = 16'd2;
            x2 = 16'd3; y2 = 16'd6;


            #1;



            check_outputs(32'd0, 32'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative slope (m=-3, b=16)", test_num);
            x1 = 16'd2; y1 = 16'd10;
            x2 = 16'd4; y2 = 16'd4;


            #1;



            check_outputs(32'd16, 32'hFFFFFFFD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal line (m=0, b=100)", test_num);
            x1 = 16'd5;  y1 = 16'd100;
            x2 = 16'd15; y2 = 16'd100;


            #1;



            check_outputs(32'd100, 32'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative intercept (m=2, b=-15)", test_num);
            x1 = 16'd10; y1 = 16'd5;
            x2 = 16'd20; y2 = 16'd25;


            #1;



            check_outputs(32'hFFFFFFF1, 32'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Larger values (m=30, b=-2000)", test_num);
            x1 = 16'd100; y1 = 16'd1000;
            x2 = 16'd200; y2 = 16'd4000;


            #1;



            check_outputs(32'hFFFFF830, 32'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative coordinates (m=2, b=0)", test_num);
            x1 = 16'hFFF6; y1 = 16'hFFEC;
            x2 = 16'h000A; y2 = 16'h0014;


            #1;



            check_outputs(32'd0, 32'd2);
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
