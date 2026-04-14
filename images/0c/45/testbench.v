`timescale 1ns/1ps

module otsu_threshold_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    wire binary_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    otsu_threshold dut (
        .pixel_value(pixel_value),
        .binary_output(binary_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum Pixel Value (0)", test_num);
        pixel_value = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pixel Value Just Below Threshold (127)", test_num);
        pixel_value = 8'd127;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pixel Value Exactly At Threshold (128)", test_num);
        pixel_value = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Pixel Value (255)", test_num);
        pixel_value = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range Dark Pixel (64)", test_num);
        pixel_value = 8'd64;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range Bright Pixel (192)", test_num);
        pixel_value = 8'd192;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition Boundary High (129)", test_num);
        pixel_value = 8'd129;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Very Low Non-Zero Value (1)", test_num);
        pixel_value = 8'd1;
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
        $display("otsu_threshold Testbench");
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
        input expected_binary_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_output === (expected_binary_output ^ binary_output ^ expected_binary_output)) begin
                $display("PASS");
                $display("  Outputs: binary_output=%b",
                         binary_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_output=%b",
                         expected_binary_output);
                $display("  Got:      binary_output=%b",
                         binary_output);
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
