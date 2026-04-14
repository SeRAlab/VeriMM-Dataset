`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_a;
    reg [7:0] pixel_b;
    reg select;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_a(pixel_a),
        .pixel_b(pixel_b),
        .select(select),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel A (Minimum value)", test_num);
        pixel_a = 8'h00;
        pixel_b = 8'hFF;
        select = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel B (Maximum value)", test_num);
        pixel_a = 8'h00;
        pixel_b = 8'hFF;
        select = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel A (Mid-range value)", test_num);
        pixel_a = 8'hA5;
        pixel_b = 8'h5A;
        select = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel B (Mid-range value)", test_num);
        pixel_a = 8'hA5;
        pixel_b = 8'h5A;
        select = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both pixels same value (Select A)", test_num);
        pixel_a = 8'h77;
        pixel_b = 8'h77;
        select = 1'b0;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both pixels same value (Select B)", test_num);
        pixel_a = 8'h77;
        pixel_b = 8'h77;
        select = 1'b1;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values (Select A)", test_num);
        pixel_a = 8'hFE;
        pixel_b = 8'h01;
        select = 1'b0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values (Select B)", test_num);
        pixel_a = 8'hFE;
        pixel_b = 8'h01;
        select = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        input [7:0] expected_interpolated_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_pixel === (expected_interpolated_pixel ^ interpolated_pixel ^ expected_interpolated_pixel)) begin
                $display("PASS");
                $display("  Outputs: interpolated_pixel=%h",
                         interpolated_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_pixel=%h",
                         expected_interpolated_pixel);
                $display("  Got:      interpolated_pixel=%h",
                         interpolated_pixel);
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
