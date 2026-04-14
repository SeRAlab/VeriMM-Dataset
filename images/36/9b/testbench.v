`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [7:0] y0;
    wire [7:0] y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y0(y0),
        .y1(y1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;

            #1;


            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Constant Values", test_num);
            x0 = 8'd100; x1 = 8'd100; x2 = 8'd250; x3 = 8'd250;

            #1;


            check_outputs(8'd100, 8'd250);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Averaging", test_num);
            x0 = 8'd10; x1 = 8'd20; x2 = 8'd40; x3 = 8'd60;

            #1;


            check_outputs(8'd15, 8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values", test_num);
            x0 = 8'hFF; x1 = 8'hFF; x2 = 8'hFF; x3 = 8'hFF;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Truncation Check (Odd Sums)", test_num);
            x0 = 8'd10; x1 = 8'd11; x2 = 8'd20; x3 = 8'd21;

            #1;


            check_outputs(8'd10, 8'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Gradients", test_num);
            x0 = 8'd0; x1 = 8'd200; x2 = 8'd255; x3 = 8'd1;

            #1;


            check_outputs(8'd100, 8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Values", test_num);
            x0 = 8'd50; x1 = 8'd150; x2 = 8'd0; x3 = 8'd100;

            #1;


            check_outputs(8'd100, 8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [7:0] expected_y0;
        input [7:0] expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%h, y1=%h",
                         y0, y1);
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
