`timescale 1ns/1ps

module activation_function_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] threshold;
    reg [7:0] x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    activation_function dut (
        .threshold(threshold),
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 8'd50;
        threshold = 8'd100;
        $display("Test %0d: x < threshold (50 < 100)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 8'd100;
        threshold = 8'd100;
        $display("Test %0d: x == threshold (100 == 100)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 8'd150;
        threshold = 8'd100;
        $display("Test %0d: x > threshold (150 > 100)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 8'd0;
        threshold = 8'd0;
        $display("Test %0d: Both zero (0 >= 0)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 8'd255;
        threshold = 8'd255;
        $display("Test %0d: Both max (255 >= 255)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 8'd0;
        threshold = 8'd255;
        $display("Test %0d: x min, threshold max (0 < 255)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 8'd255;
        threshold = 8'd0;
        $display("Test %0d: x max, threshold min (255 > 0)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 8'd127;
        threshold = 8'd128;
        $display("Test %0d: Boundary check (127 < 128)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 8'd128;
        threshold = 8'd127;
        $display("Test %0d: Boundary check (128 > 127)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 8'd42;
        threshold = 8'd43;
        $display("Test %0d: Off-by-one (42 < 43)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("activation_function Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
