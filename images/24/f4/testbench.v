`timescale 1ns/1ps

module rle_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [3:0] count_out;
    wire [3:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_compressor dut (
        .pixel_in(pixel_in),
        .count_out(count_out),
        .pixel_out(pixel_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero input (black pixel)", test_num);
            pixel_in = 8'h00;

            #1;


            check_outputs(4'd1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-one input (white pixel)", test_num);
            pixel_in = 8'hFF;

            #1;


            check_outputs(4'd1, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range value (0x80)", test_num);
            pixel_in = 8'h80;

            #1;


            check_outputs(4'd1, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low nibble variations (0x10 vs 0x1F)", test_num);
            pixel_in = 8'h10;
            #1;

            check_outputs(4'd1, 4'h1);

            pixel_in = 8'h1F;

            #1;


            check_outputs(4'd1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 1 (0xA5)", test_num);
            pixel_in = 8'hA5;

            #1;


            check_outputs(4'd1, 4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 2 (0x5A)", test_num);
            pixel_in = 8'h5A;

            #1;


            check_outputs(4'd1, 4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying statelessness (Repeated Input)", test_num);
            pixel_in = 8'hCC;
            #1;

            check_outputs(4'd1, 4'hC);
            #10;
            pixel_in = 8'hCC;


            #1;



            check_outputs(4'd1, 4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary values around nibble thresholds", test_num);
            pixel_in = 8'h7F;
            #1;

            check_outputs(4'd1, 4'h7);

            pixel_in = 8'h80;
            #1;

            check_outputs(4'd1, 4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_compressor Testbench");
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
        input [3:0] expected_count_out;
        input [3:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, pixel_out=%h",
                         count_out, pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, pixel_out=%h",
                         expected_count_out, expected_pixel_out);
                $display("  Got:      count_out=%h, pixel_out=%h",
                         count_out, pixel_out);
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
