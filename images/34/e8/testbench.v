`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    reg [3:0] x_in;
    reg [3:0] y_in;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_in(pixel_in),
        .x_in(x_in),
        .y_in(y_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Origin coordinate (0,0) with pattern 0xAA", test_num);
        pixel_in = 8'hAA;
        x_in = 4'd0;
        y_in = 4'd0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum coordinates (15,15) with pattern 0x55", test_num);
        pixel_in = 8'h55;
        x_in = 4'd15;
        y_in = 4'd15;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range coordinate (7,8) with all ones", test_num);
        pixel_in = 8'hFF;
        x_in = 4'd7;
        y_in = 4'd8;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Coordinate (4,2) with zero pixel", test_num);
        pixel_in = 8'h00;
        x_in = 4'd4;
        y_in = 4'd2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random-style coordinate (12,3) with value 0xBE", test_num);
        pixel_in = 8'hBE;
        x_in = 4'd12;
        y_in = 4'd3;
        #1;

        check_outputs(8'hBE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary coordinate (0,15) with value 0x12", test_num);
        pixel_in = 8'h12;
        x_in = 4'd0;
        y_in = 4'd15;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary coordinate (15,0) with value 0xEF", test_num);
        pixel_in = 8'hEF;
        x_in = 4'd15;
        y_in = 4'd0;
        #1;

        check_outputs(8'hEF);
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
