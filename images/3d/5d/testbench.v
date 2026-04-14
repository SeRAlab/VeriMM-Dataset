`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [1:0] x_interp;
    reg [1:0] y_interp;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .x_interp(x_interp),
        .y_interp(y_interp),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel_00 = 8'hAA; pixel_01 = 8'hBB;
        pixel_10 = 8'hCC; pixel_11 = 8'hDD;
        x_interp = 2'b00; y_interp = 2'b00;
        $display("Test %0d: Top-Left corner", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel_00 = 8'h11; pixel_01 = 8'h22;
        pixel_10 = 8'h33; pixel_11 = 8'h44;
        x_interp = 2'b10; y_interp = 2'b00;
        $display("Test %0d: Top-Right (at x-threshold 0.5)", test_num);
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel_00 = 8'h05; pixel_01 = 8'h10;
        pixel_10 = 8'hFF; pixel_11 = 8'hA0;
        x_interp = 2'b01; y_interp = 2'b11;
        $display("Test %0d: Bottom-Left (x < 0.5, y > 0.5)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel_00 = 8'hDE; pixel_01 = 8'hAD;
        pixel_10 = 8'hBE; pixel_11 = 8'hEF;
        x_interp = 2'b10; y_interp = 2'b10;
        $display("Test %0d: Bottom-Right (at both thresholds 0.5)", test_num);
        #1;

        check_outputs(8'hEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel_00 = 8'h55; pixel_01 = 8'h66;
        pixel_10 = 8'h77; pixel_11 = 8'h88;
        x_interp = 2'b01; y_interp = 2'b01;
        $display("Test %0d: Boundary Round Down (0.25, 0.25)", test_num);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel_00 = 8'h42; pixel_01 = 8'h42;
        pixel_10 = 8'h42; pixel_11 = 8'h42;
        x_interp = 2'b11; y_interp = 2'b00;
        $display("Test %0d: Uniform color block", test_num);
        #1;

        check_outputs(8'h42);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixel_00 = 8'h00; pixel_01 = 8'hFF;
        pixel_10 = 8'h00; pixel_11 = 8'h00;
        x_interp = 2'b11; y_interp = 2'b01;
        $display("Test %0d: Max brightness pixel selection", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pixel_00 = 8'h10; pixel_01 = 8'h20;
        pixel_10 = 8'h30; pixel_11 = 8'h40;
        x_interp = 2'b00; y_interp = 2'b11;
        $display("Test %0d: Lower-Left edge (0.0, 0.75)", test_num);
        #1;

        check_outputs(8'h30);
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
