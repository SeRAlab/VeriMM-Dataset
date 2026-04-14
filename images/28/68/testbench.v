`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel1;
    reg [7:0] pixel2;
    reg select;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel1(pixel1),
        .pixel2(pixel2),
        .select(select),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Pixel 1 (Basic)", test_num);
            pixel1 = 8'hA5;
            pixel2 = 8'h5A;
            select = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Pixel 2 (Basic)", test_num);
            pixel1 = 8'hA5;
            pixel2 = 8'h5A;
            select = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selection with All Zeros", test_num);
            pixel1 = 8'h00;
            pixel2 = 8'hFF;
            select = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selection with All Ones", test_num);
            pixel1 = 8'h00;
            pixel2 = 8'hFF;
            select = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Intermediate value Pixel 1", test_num);
            pixel1 = 8'd127;
            pixel2 = 8'd200;
            select = 1'b0;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Intermediate value Pixel 2", test_num);
            pixel1 = 8'd127;
            pixel2 = 8'd200;
            select = 1'b1;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal Pixels Select 0", test_num);
            pixel1 = 8'h42;
            pixel2 = 8'h42;
            select = 1'b0;
            #1;

            check_outputs(8'h42);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal Pixels Select 1", test_num);
            pixel1 = 8'h42;
            pixel2 = 8'h42;
            select = 1'b1;
            #1;

            check_outputs(8'h42);
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
