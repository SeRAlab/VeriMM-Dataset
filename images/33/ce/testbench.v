`timescale 1ns/1ps

module thresholding_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    reg [2:0] threshold;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thresholding dut (
        .pixel_value(pixel_value),
        .threshold(threshold),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Equality at low range (Pixel=5, Threshold=5)", test_num);
        pixel_value = 8'd5;
        threshold = 3'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Pixel just above threshold (Pixel=4, Threshold=3)", test_num);
        pixel_value = 8'd4;
        threshold = 3'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Pixel just below threshold (Pixel=2, Threshold=3)", test_num);
        pixel_value = 8'd2;
        threshold = 3'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Maximum values (Pixel=255, Threshold=7)", test_num);
        pixel_value = 8'd255;
        threshold = 3'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Zero values (Pixel=0, Threshold=0)", test_num);
        pixel_value = 8'd0;
        threshold = 3'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Zero pixel, non-zero threshold (Pixel=0, Threshold=1)", test_num);
        pixel_value = 8'd0;
        threshold = 3'd1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: High pixel vs max threshold (Pixel=128, Threshold=7)", test_num);
        pixel_value = 8'd128;
        threshold = 3'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Mid-range comparison (Pixel=3, Threshold=4)", test_num);
        pixel_value = 8'd3;
        threshold = 3'd4;
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
        $display("thresholding Testbench");
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
