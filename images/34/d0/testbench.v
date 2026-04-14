`timescale 1ns/1ps

module png_compression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in1;
    reg [7:0] pixel_in2;
    wire [7:0] compressed_out1;
    wire [7:0] compressed_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compression dut (
        .pixel_in1(pixel_in1),
        .pixel_in2(pixel_in2),
        .compressed_out1(compressed_out1),
        .compressed_out2(compressed_out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Positive Difference", test_num);
            pixel_in1 = 8'd50;
            pixel_in2 = 8'd70;

            #1;


            check_outputs(8'd50, 8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Negative Difference", test_num);
            pixel_in1 = 8'd100;
            pixel_in2 = 8'd80;

            #1;


            check_outputs(8'd100, 8'hEC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identical Pixels", test_num);
            pixel_in1 = 8'hAA;
            pixel_in2 = 8'hAA;

            #1;


            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Positive Increase", test_num);
            pixel_in1 = 8'd0;
            pixel_in2 = 8'd255;

            #1;


            check_outputs(8'd0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Negative Decrease", test_num);
            pixel_in1 = 8'd255;
            pixel_in2 = 8'd0;

            #1;


            check_outputs(8'd255, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small to Large", test_num);
            pixel_in1 = 8'h01;
            pixel_in2 = 8'h02;

            #1;


            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Midpoint Difference", test_num);
            pixel_in1 = 8'd128;
            pixel_in2 = 8'd0;

            #1;


            check_outputs(8'h80, 8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compression Testbench");
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
        input [7:0] expected_compressed_out1;
        input [7:0] expected_compressed_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_out1 === (expected_compressed_out1 ^ compressed_out1 ^ expected_compressed_out1) &&
                expected_compressed_out2 === (expected_compressed_out2 ^ compressed_out2 ^ expected_compressed_out2)) begin
                $display("PASS");
                $display("  Outputs: compressed_out1=%h, compressed_out2=%h",
                         compressed_out1, compressed_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out1=%h, compressed_out2=%h",
                         expected_compressed_out1, expected_compressed_out2);
                $display("  Got:      compressed_out1=%h, compressed_out2=%h",
                         compressed_out1, compressed_out2);
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
