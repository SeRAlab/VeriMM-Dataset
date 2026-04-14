`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    reg [4:0] x1;
    reg [4:0] x2;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs positive one", test_num);
            x = 5'sd1; x1 = 5'sd1; x2 = 5'sd1;
            #1;

            check_outputs(5'sd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            x = 5'sd0; x1 = 5'sd0; x2 = 5'sd0;
            #1;

            check_outputs(5'sd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs negative one", test_num);
            x = -5'sd1; x1 = -5'sd1; x2 = -5'sd1;
            #1;

            check_outputs(-5'sd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse response at x (h0)", test_num);
            x = 5'sd5; x1 = 5'sd0; x2 = 5'sd0;
            #1;

            check_outputs(5'sd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse response at x1 (h1)", test_num);
            x = 5'sd0; x1 = 5'sd5; x2 = 5'sd0;
            #1;

            check_outputs(5'sd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse response at x2 (h2)", test_num);
            x = 5'sd0; x1 = 5'sd0; x2 = 5'sd5;
            #1;

            check_outputs(5'sd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum positive sum without overflow", test_num);
            x = 5'sd3; x1 = 5'sd5; x2 = 5'sd2;
            #1;

            check_outputs(5'sd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum negative sum without overflow", test_num);
            x = -5'sd4; x1 = -5'sd5; x2 = -5'sd2;
            #1;

            check_outputs(-5'sd16);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed signs", test_num);
            x = 5'sd7; x1 = -5'sd3; x2 = 5'sd2;
            #1;

            check_outputs(5'sd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Overflow Check (Wrap-around)", test_num);
            x = 5'sd7; x1 = 5'sd7; x2 = 5'sd7;

            #1;


            check_outputs(-5'sd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [4:0] expected_y;
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
