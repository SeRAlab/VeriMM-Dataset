`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] filter;
    reg [8:0] pixel_data;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .filter(filter),
        .pixel_data(pixel_data),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All zeros input", test_num);
            pixel_data = 9'b000_000_000;
            filter = 3'b000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Max pixels, no filter", test_num);
            pixel_data = 9'b111_111_111;
            filter = 3'b000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: No pixels, max filter", test_num);
            pixel_data = 9'b000_000_000;
            filter = 3'b111;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: All pixels and filter coefficients high (Max Result)", test_num);
            pixel_data = 9'b111_111_111;
            filter = 3'b111;

            #1;


            check_outputs(8'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Filter active on bit 0 only", test_num);
            pixel_data = 9'b100_100_101;
            filter = 3'b001;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Filter active on bit 2 only", test_num);
            pixel_data = 9'b100_100_100;
            filter = 3'b100;

            #1;


            check_outputs(8'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Mixed pattern 1 (Checkerboard)", test_num);
            pixel_data = 9'b101_010_101;
            filter = 3'b101;




            #1;





            check_outputs(8'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Single pixel in center", test_num);
            pixel_data = 9'b000_010_000;
            filter = 3'b111;


            #1;



            check_outputs(8'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Mixed pattern 2", test_num);
            pixel_data = 9'b110_011_101;
            filter = 3'b011;




            #1;





            check_outputs(8'd4);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: First row only", test_num);
            pixel_data = 9'b000_000_111;
            filter = 3'b111;
            #1;

            check_outputs(8'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
