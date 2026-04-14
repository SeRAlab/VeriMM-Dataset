`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] original_pixel;
    reg [1:0] x_coord;
    reg [1:0] y_coord;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .original_pixel(original_pixel),
        .x_coord(x_coord),
        .y_coord(y_coord),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0xA5 at (0,0)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'hA5; x_coord = 2'b00; y_coord = 2'b00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0x5A at (1,1)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'h5A; x_coord = 2'b01; y_coord = 2'b01;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0xFF at (2,2)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'hFF; x_coord = 2'b10; y_coord = 2'b10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0x12 at (3,3)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'h12; x_coord = 2'b11; y_coord = 2'b11;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0x00 at (0,3)", test_num);

        original_pixel = 8'hFF; x_coord = 2'b01; y_coord = 2'b01; #5;

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b11;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0x7F at (3,0)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'h7F; x_coord = 2'b11; y_coord = 2'b00;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0xBC at (1,2)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'hBC; x_coord = 2'b01; y_coord = 2'b10;
        #1;

        check_outputs(8'hBC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input Pixel 0x33 at (2,1)", test_num);

        original_pixel = 8'h00; x_coord = 2'b00; y_coord = 2'b00; #5;

        original_pixel = 8'h33; x_coord = 2'b10; y_coord = 2'b01;
        #1;

        check_outputs(8'h33);
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
