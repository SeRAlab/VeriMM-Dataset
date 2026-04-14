`timescale 1ns/1ps

module dwt_haar_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] a;
    wire [7:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_haar dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .a(a),
        .d(d)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: DC Signal (Constant)", test_num);
            x0 = 8'd100; x1 = 8'd100; x2 = 8'd100; x3 = 8'd100;

            #1;


            check_outputs(8'd100, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Positive Step Function", test_num);
            x0 = 8'd200; x1 = 8'd200; x2 = 8'd0; x3 = 8'd0;

            #1;


            check_outputs(8'd100, 8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative Step Function", test_num);
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd200; x3 = 8'd200;

            #1;


            check_outputs(8'd100, 8'h9C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum Values", test_num);
            x0 = 8'd255; x1 = 8'd255; x2 = 8'd255; x3 = 8'd255;

            #1;


            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: High Frequency (Alternating)", test_num);
            x0 = 8'd200; x1 = 8'd0; x2 = 8'd200; x3 = 8'd0;


            #1;



            check_outputs(8'd100, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Impulse at Start", test_num);
            x0 = 8'd120; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;

            #1;


            check_outputs(8'd30, 8'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_haar Testbench");
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
        input [7:0] expected_a;
        input [7:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: a=%h, d=%h",
                         a, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, d=%h",
                         expected_a, expected_d);
                $display("  Got:      a=%h, d=%h",
                         a, d);
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
