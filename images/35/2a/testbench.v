`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [1:0] x;
    reg [1:0] y;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .x(x),
        .y(y),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Top-Left quadrant (pixel00) - Center point", test_num);
        pixel00 = 8'hAA; pixel01 = 8'hBB; pixel10 = 8'hCC; pixel11 = 8'hDD;
        x = 2'b00; y = 2'b00;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Top-Left quadrant (pixel00) - Boundary point", test_num);
        pixel00 = 8'hAA; pixel01 = 8'hBB; pixel10 = 8'hCC; pixel11 = 8'hDD;
        x = 2'b01; y = 2'b01;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Top-Right quadrant (pixel01) - Center point", test_num);
        pixel00 = 8'h10; pixel01 = 8'h20; pixel10 = 8'h30; pixel11 = 8'h40;
        x = 2'b11; y = 2'b00;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Top-Right quadrant (pixel01) - Boundary point", test_num);
        pixel00 = 8'h10; pixel01 = 8'h20; pixel10 = 8'h30; pixel11 = 8'h40;
        x = 2'b10; y = 2'b01;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bottom-Left quadrant (pixel10) - Center point", test_num);
        pixel00 = 8'h01; pixel01 = 8'h02; pixel10 = 8'h03; pixel11 = 8'h04;
        x = 2'b00; y = 2'b11;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bottom-Left quadrant (pixel10) - Boundary point", test_num);
        pixel00 = 8'h01; pixel01 = 8'h02; pixel10 = 8'h03; pixel11 = 8'h04;
        x = 2'b01; y = 2'b10;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Bottom-Right quadrant (pixel11) - Center point", test_num);
        pixel00 = 8'hFF; pixel01 = 8'hEE; pixel10 = 8'hDD; pixel11 = 8'hCC;
        x = 2'b11; y = 2'b11;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Bottom-Right quadrant (pixel11) - Boundary point", test_num);
        pixel00 = 8'hFF; pixel01 = 8'hEE; pixel10 = 8'hDD; pixel11 = 8'hCC;
        x = 2'b10; y = 2'b10;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: All pixels identical value", test_num);
        pixel00 = 8'h55; pixel01 = 8'h55; pixel10 = 8'h55; pixel11 = 8'h55;
        x = 2'b01; y = 2'b11;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Zero values test", test_num);
        pixel00 = 8'h00; pixel01 = 8'hFF; pixel10 = 8'hFF; pixel11 = 8'hFF;
        x = 2'b00; y = 2'b01;
        #1;

        check_outputs(8'h00);
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
