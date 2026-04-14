`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel_values;
    wire [9:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel_values(pixel_values),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Pixels Zero", test_num);
        pixel_values = 9'b000_000_000;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Vertical Line (Right Column)", test_num);

        pixel_values = 9'b100_100_100;



        #1;




        check_outputs(10'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Horizontal Line (Bottom Row)", test_num);

        pixel_values = 9'b111_000_000;



        #1;




        check_outputs(10'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Vertical Line (Left Column)", test_num);

        pixel_values = 9'b001_001_001;



        #1;




        check_outputs(10'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Horizontal Line (Top Row)", test_num);

        pixel_values = 9'b000_000_111;



        #1;




        check_outputs(10'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Corner Block (Top-Left)", test_num);

        pixel_values = 9'b000_011_011;



        #1;




        check_outputs(10'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Center Pixel", test_num);

        pixel_values = 9'b000_010_000;

        #1;


        check_outputs(10'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Pixels One", test_num);
        pixel_values = 9'b111_111_111;


        #1;



        check_outputs(10'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Diagonal Edge", test_num);

        pixel_values = 9'b000_100_110;



        #1;




        check_outputs(10'd6);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bottom Right L-Shape", test_num);

        pixel_values = 9'b110_110_000;



        #1;




        check_outputs(10'd6);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detection Testbench");
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
        input [9:0] expected_gradient_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gradient_magnitude === (expected_gradient_magnitude ^ gradient_magnitude ^ expected_gradient_magnitude)) begin
                $display("PASS");
                $display("  Outputs: gradient_magnitude=%h",
                         gradient_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gradient_magnitude=%h",
                         expected_gradient_magnitude);
                $display("  Got:      gradient_magnitude=%h",
                         gradient_magnitude);
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
