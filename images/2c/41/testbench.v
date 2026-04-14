`timescale 1ns/1ps

module hough_transform_accumulator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_image;
    wire [3:0] accumulator;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform_accumulator dut (
        .binary_image(binary_image),
        .accumulator(accumulator)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            binary_image = 16'h0000;
            $display("Test %0d: No edge pixels (0x0000)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            binary_image = 16'h0001;
            $display("Test %0d: Single edge pixel (0x0001)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            binary_image = 16'h000F;
            $display("Test %0d: Four edge pixels (0x000F)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            binary_image = 16'hAAAA;
            $display("Test %0d: Alternating edge pixels (0xAAAA)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            binary_image = 16'h5555;
            $display("Test %0d: Alternating edge pixels (0x5555)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            binary_image = 16'h7FFF;
            $display("Test %0d: Max 4-bit capacity (0x7FFF)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            binary_image = 16'hF0F0;
            $display("Test %0d: Grouped edge pixels (0xF0F0)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            binary_image = 16'h1234;
            $display("Test %0d: Arbitrary pattern (0x1234)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform_accumulator Testbench");
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
        input [3:0] expected_accumulator;
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
