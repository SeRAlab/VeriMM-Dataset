`timescale 1ns/1ps

module png_filter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] filter_type;
    reg [7:0] left_pixel;
    reg [7:0] pixel;
    reg [7:0] previous_pixel;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_filter dut (
        .filter_type(filter_type),
        .left_pixel(left_pixel),
        .pixel(pixel),
        .previous_pixel(previous_pixel),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Filter Type None (0)", test_num);

            filter_type = 3'd0;
            pixel = 8'hA5;
            left_pixel = 8'h12;
            previous_pixel = 8'h34;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Filter Type Sub (1)", test_num);
            filter_type = 3'd1;
            pixel = 8'h50;
            left_pixel = 8'h20;
            previous_pixel = 8'h00;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Filter Type Sub (1) Underflow", test_num);
            filter_type = 3'd1;
            pixel = 8'h10;
            left_pixel = 8'h20;
            previous_pixel = 8'h00;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Filter Type Up (2)", test_num);
            filter_type = 3'd2;
            pixel = 8'h80;
            left_pixel = 8'h00;
            previous_pixel = 8'h30;

            #1;


            check_outputs(8'h50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Filter Type Up (2) Underflow", test_num);
            filter_type = 3'd2;
            pixel = 8'h05;
            left_pixel = 8'h00;
            previous_pixel = 8'h10;

            #1;


            check_outputs(8'hF5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Filter Type Average (3)", test_num);
            filter_type = 3'd3;
            pixel = 8'h40;
            left_pixel = 8'h20;
            previous_pixel = 8'h20;

            #1;


            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Filter Type Average (3) Floor Check", test_num);
            filter_type = 3'd3;
            pixel = 8'h10;
            left_pixel = 8'h05;
            previous_pixel = 8'h06;

            #1;


            check_outputs(8'h0B);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %03d: Filter Type Average (3) Carry Check", test_num);
            filter_type = 3'd3;
            pixel = 8'hFF;
            left_pixel = 8'hFF;
            previous_pixel = 8'hFF;

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
        $display("png_filter Testbench");
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
        input [7:0] expected_filtered_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filtered_pixel === (expected_filtered_pixel ^ filtered_pixel ^ expected_filtered_pixel)) begin
                $display("PASS");
                $display("  Outputs: filtered_pixel=%h",
                         filtered_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_pixel=%h",
                         expected_filtered_pixel);
                $display("  Got:      filtered_pixel=%h",
                         filtered_pixel);
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
