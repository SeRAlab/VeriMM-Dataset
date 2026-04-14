`timescale 1ns/1ps

module IFFT_4point_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x0;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    wire [3:0] y0;
    wire [3:0] y1;
    wire [3:0] y2;
    wire [3:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT_4point dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            x0 = 4'h0; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unit Impulse at Bin 0 (DC)", test_num);

            x0 = 4'h1; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            #1;

            check_outputs(4'h1, 4'h1, 4'h1, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant Input (DC in Frequency)", test_num);


            x0 = 4'h1; x1 = 4'h1; x2 = 4'h1; x3 = 4'h1;
            #1;

            check_outputs(4'h4, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating +/- 1", test_num);


            x0 = 4'h1; x1 = 4'hF; x2 = 4'h1; x3 = 4'hF;
            #1;

            check_outputs(4'h0, 4'h0, 4'h4, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Imaginary Component Cancellation", test_num);


            x0 = 4'h0; x1 = 4'h1; x2 = 4'h0; x3 = 4'h1;
            #1;

            check_outputs(4'h2, 4'h0, 4'hE, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative DC Impulse", test_num);

            x0 = 4'hF; x1 = 4'h0; x2 = 4'h0; x3 = 4'h0;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center Shifted Impulse", test_num);


            x0 = 4'h1; x1 = 4'h0; x2 = 4'hF; x3 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h2, 4'h0, 4'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT_4point Testbench");
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
        input [3:0] expected_y0;
        input [3:0] expected_y1;
        input [3:0] expected_y2;
        input [3:0] expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h, y2=%h, y3=%h",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
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
