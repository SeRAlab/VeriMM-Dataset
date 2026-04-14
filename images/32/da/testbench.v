`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [1:0] x_in;
    reg [1:0] y_in;
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
        .x_in(x_in),
        .y_in(y_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Top-Left Quadrant - Corner (0,0)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b00; y_in = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Top-Left Quadrant - Boundary (1,1)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b01; y_in = 2'b01;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Top-Right Quadrant - Corner (2,0)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b10; y_in = 2'b00;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Top-Right Quadrant - Boundary (3,1)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b11; y_in = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bottom-Left Quadrant - Corner (0,2)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b00; y_in = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bottom-Left Quadrant - Boundary (1,3)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b01; y_in = 2'b11;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bottom-Right Quadrant - Corner (2,2)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b10; y_in = 2'b10;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bottom-Right Quadrant - Boundary (3,3)", test_num);
            pixel_00 = 8'hAA; pixel_01 = 8'hBB; pixel_10 = 8'hCC; pixel_11 = 8'hDD;
            x_in = 2'b11; y_in = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Verification with New Pixel Values", test_num);
            pixel_00 = 8'h12; pixel_01 = 8'h34; pixel_10 = 8'h56; pixel_11 = 8'h78;
            x_in = 2'b11; y_in = 2'b00;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Uniform Image Test", test_num);
            pixel_00 = 8'hFF; pixel_01 = 8'hFF; pixel_10 = 8'hFF; pixel_11 = 8'hFF;
            x_in = 2'b01; y_in = 2'b10;
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
        testcase009();
        testcase010();
        
        
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
