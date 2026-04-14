`timescale 1ns/1ps

module thresholding_otsu_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel;
    wire binary_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thresholding_otsu dut (
        .pixel(pixel),
        .binary_output(binary_output)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel = 8'd0;
        #10;
        $display("Test Case 001: Pixel = %d", pixel);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel = 8'd255;
        #10;
        $display("Test Case 002: Pixel = %d", pixel);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel = 8'd45;
        #10;
        $display("Test Case 003: Pixel = %d", pixel);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel = 8'd210;
        #10;
        $display("Test Case 004: Pixel = %d", pixel);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel = 8'd127;
        #10;
        $display("Test Case 005: Pixel = %d", pixel);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel = 8'd128;
        #10;
        $display("Test Case 006: Pixel = %d", pixel);
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thresholding_otsu Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
