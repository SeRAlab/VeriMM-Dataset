`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] angle;
    reg [63:0] binary_image;
    wire [15:0] accumulator;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .angle(angle),
        .binary_image(binary_image),
        .accumulator(accumulator)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Empty Image - All angles should return 0", test_num);
        binary_image = 64'h0;

        angle = 3'd0;
        #1;

        check_outputs(16'd0);

        angle = 3'd1;
        #1;

        check_outputs(16'd0);

        angle = 3'd2;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Vertical Line at Column 0", test_num);

        binary_image = 64'h0101010101010101;

        angle = 3'd0;
        #1;

        check_outputs(16'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal Line at Row 7", test_num);

        binary_image = 64'hFF00000000000000;

        angle = 3'd2;
        #1;

        check_outputs(16'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Main Diagonal Line (x=y)", test_num);

        binary_image = 64'h8040201008040201;

        angle = 3'd1;
        #1;

        check_outputs(16'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Noisy Vertical - Column 2 has 5 pixels", test_num);

        binary_image = 64'h0000000404040404;

        angle = 3'd0;
        #1;

        check_outputs(16'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Image - Peak should be 8 for any orthogonal angle", test_num);
        binary_image = 64'hFFFFFFFFFFFFFFFF;

        angle = 3'd2;
        #1;

        check_outputs(16'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sparse Scattered Pixels (Max line length 1)", test_num);

        binary_image = 64'h0000000040100401;

        angle = 3'd0;
        #1;

        check_outputs(16'd1);

        angle = 3'd2;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Cross Pattern (Row 3 and Col 3 full)", test_num);


        binary_image = 64'h08080808FF080808;

        angle = 3'd0;
        #1;

        check_outputs(16'd8);

        angle = 3'd2;
        #1;

        check_outputs(16'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_accumulator;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accumulator === (expected_accumulator ^ accumulator ^ expected_accumulator)) begin
                $display("PASS");
                $display("  Outputs: accumulator=%h",
                         accumulator);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accumulator=%h",
                         expected_accumulator);
                $display("  Got:      accumulator=%h",
                         accumulator);
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
