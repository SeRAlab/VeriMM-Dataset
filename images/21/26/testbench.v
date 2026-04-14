`timescale 1ns/1ps

module png_filter_sub_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_pixel;
    reg [7:0] previous_pixel;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_filter_sub dut (
        .current_pixel(current_pixel),
        .previous_pixel(previous_pixel),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: First pixel in row (previous_pixel = 0)", test_num);
        current_pixel = 8'hA5;
        previous_pixel = 8'h00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Standard subtraction (current > previous)", test_num);
        current_pixel = 8'd150;
        previous_pixel = 8'd100;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Result is zero (current == previous)", test_num);
        current_pixel = 8'h7F;
        previous_pixel = 8'h7F;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Underflow case (current < previous)", test_num);
        current_pixel = 8'd10;
        previous_pixel = 8'd20;
        #1;

        check_outputs(8'hF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum boundary values", test_num);
        current_pixel = 8'hFF;
        previous_pixel = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Minimum boundary with underflow", test_num);
        current_pixel = 8'h00;
        previous_pixel = 8'hFF;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mid-range values", test_num);
        current_pixel = 8'h80;
        previous_pixel = 8'h01;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Extreme wrap-around check", test_num);
        current_pixel = 8'h01;
        previous_pixel = 8'h02;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_filter_sub Testbench");
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
        input [7:0] expected_filtered_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filtered_pixel === (expected_filtered_pixel ^ filtered_pixel ^ expected_filtered_pixel)) begin
                $display("PASS");
                $display("  Outputs: filtered_pixel=%h",
                         filtered_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_pixel=%h",
                         expected_filtered_pixel);
                $display("  Got:      filtered_pixel=%h",
                         filtered_pixel);
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
