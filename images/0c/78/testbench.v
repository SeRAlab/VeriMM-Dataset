`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_a;
    reg [7:0] pixel_b;
    reg [7:0] pixel_c;
    reg [7:0] pixel_d;
    reg [1:0] select;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_a(pixel_a),
        .pixel_b(pixel_b),
        .pixel_c(pixel_c),
        .pixel_d(pixel_d),
        .select(select),
        .output_pixel(output_pixel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel A (select = 00)", test_num);
        pixel_a = 8'h11;
        pixel_b = 8'h22;
        pixel_c = 8'h33;
        pixel_d = 8'h44;
        select = 2'b00;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel B (select = 01)", test_num);
        pixel_a = 8'h11;
        pixel_b = 8'h22;
        pixel_c = 8'h33;
        pixel_d = 8'h44;
        select = 2'b01;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel C (select = 10)", test_num);
        pixel_a = 8'h11;
        pixel_b = 8'h22;
        pixel_c = 8'h33;
        pixel_d = 8'h44;
        select = 2'b10;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Pixel D (select = 11)", test_num);
        pixel_a = 8'h11;
        pixel_b = 8'h22;
        pixel_c = 8'h33;
        pixel_d = 8'h44;
        select = 2'b11;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All pixels identical", test_num);
        pixel_a = 8'hFF;
        pixel_b = 8'hFF;
        pixel_c = 8'hFF;
        pixel_d = 8'hFF;
        select = 2'b01;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum value check", test_num);
        pixel_a = 8'h00;
        pixel_b = 8'h01;
        pixel_c = 8'h02;
        pixel_d = 8'h03;
        select = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum value check", test_num);
        pixel_a = 8'hFE;
        pixel_b = 8'hFD;
        pixel_c = 8'hFC;
        pixel_d = 8'hFF;
        select = 2'b11;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Dynamic selection change A to C", test_num);
        pixel_a = 8'hA1;
        pixel_b = 8'hB2;
        pixel_c = 8'hC3;
        pixel_d = 8'hD4;
        select = 2'b00;
        #5;
        select = 2'b10;
        #1;

        check_outputs(8'hC3);
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
