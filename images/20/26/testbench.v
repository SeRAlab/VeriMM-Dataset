`timescale 1ns/1ps

module grayscale_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pixel_value;
    wire [3:0] grayscale_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    grayscale_converter dut (
        .pixel_value(pixel_value),
        .grayscale_value(grayscale_value)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel_value = 4'd0;
        $display("Test Case %0d: Input = %d (Minimum value)", test_num, pixel_value);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel_value = 4'd15;
        $display("Test Case %0d: Input = %d (Maximum value)", test_num, pixel_value);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel_value = 4'd5;
        $display("Test Case %0d: Input = %d (Mid-range value)", test_num, pixel_value);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel_value = 4'd10;
        $display("Test Case %0d: Input = %d (Mid-range value)", test_num, pixel_value);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel_value = 4'd8;
        $display("Test Case %0d: Input = %d", test_num, pixel_value);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel_value = 4'd3;
        $display("Test Case %0d: Input = %d", test_num, pixel_value);
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("grayscale_converter Testbench");
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
        input [3:0] expected_grayscale_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_grayscale_value === (expected_grayscale_value ^ grayscale_value ^ expected_grayscale_value)) begin
                $display("PASS");
                $display("  Outputs: grayscale_value=%h",
                         grayscale_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grayscale_value=%h",
                         expected_grayscale_value);
                $display("  Got:      grayscale_value=%h",
                         grayscale_value);
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
