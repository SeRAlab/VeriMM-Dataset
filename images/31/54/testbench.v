`timescale 1ns/1ps

module PNG_Sub_Filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_pixel;
    reg [7:0] left_pixel;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PNG_Sub_Filter dut (
        .current_pixel(current_pixel),
        .left_pixel(left_pixel),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple subtraction (no wrap)", test_num);
            current_pixel = 8'd100;
            left_pixel = 8'd40;

            #1;


            check_outputs(8'h3C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Result is zero", test_num);
            current_pixel = 8'hAA;
            left_pixel = 8'hAA;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Underflow / Wrap-around (small - large)", test_num);
            current_pixel = 8'd50;
            left_pixel = 8'd100;

            #1;


            check_outputs(8'hCE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum current, maximum left", test_num);
            current_pixel = 8'h00;
            left_pixel = 8'hFF;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum current, minimum left", test_num);
            current_pixel = 8'hFF;
            left_pixel = 8'h00;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zeros", test_num);
            current_pixel = 8'h00;
            left_pixel = 8'h00;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Off-by-one underflow", test_num);
            current_pixel = 8'h80;
            left_pixel = 8'h81;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary values", test_num);
            current_pixel = 8'h45;
            left_pixel = 8'h12;

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
        $display("PNG_Sub_Filter Testbench");
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
