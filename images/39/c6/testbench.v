`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    reg [3:0] x_coord;
    reg [3:0] y_coord;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_value(pixel_value),
        .x_coord(x_coord),
        .y_coord(y_coord),
        .output_pixel(output_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Black pixel at origin (0,0)", test_num);
        pixel_value = 8'h00;
        x_coord = 4'd0;
        y_coord = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: White pixel at maximum coordinates (15,15)", test_num);
        pixel_value = 8'hFF;
        x_coord = 4'd15;
        y_coord = 4'd15;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range gray pixel at center-ish coordinates (7,8)", test_num);
        pixel_value = 8'h80;
        x_coord = 4'd7;
        y_coord = 4'd8;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern pixel 0x5A at coordinate (3,12)", test_num);
        pixel_value = 8'h5A;
        x_coord = 4'd3;
        y_coord = 4'd12;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern pixel 0xA5 at coordinate (14,1)", test_num);
        pixel_value = 8'hA5;
        x_coord = 4'd14;
        y_coord = 4'd1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing boundary x=0, y=15 with pixel 0x12", test_num);
        pixel_value = 8'h12;
        x_coord = 4'd0;
        y_coord = 4'd15;
        #1;

        check_outputs(8'h12);
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
        input [7:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
