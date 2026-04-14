`timescale 1ns/1ps

module jpeg_compression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    wire [2:0] compressed_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compression dut (
        .pixel_value(pixel_value),
        .compressed_value(compressed_value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Lower bound Range 0 (pixel_value = 0)", test_num);
            pixel_value = 8'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Upper bound Range 0 (pixel_value = 63)", test_num);
            pixel_value = 8'd63;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Lower bound Range 1 (pixel_value = 64)", test_num);
            pixel_value = 8'd64;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Upper bound Range 1 (pixel_value = 127)", test_num);
            pixel_value = 8'd127;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Lower bound Range 2 (pixel_value = 128)", test_num);
            pixel_value = 8'd128;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Upper bound Range 2 (pixel_value = 191)", test_num);
            pixel_value = 8'd191;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Lower bound Range 3 (pixel_value = 192)", test_num);
            pixel_value = 8'd192;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Upper bound Range 3 (pixel_value = 255)", test_num);
            pixel_value = 8'd255;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Intermediate value Range 1 (pixel_value = 100)", test_num);
            pixel_value = 8'd100;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Intermediate value Range 2 (pixel_value = 150)", test_num);
            pixel_value = 8'd150;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_compression Testbench");
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
        input [2:0] expected_compressed_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_value === (expected_compressed_value ^ compressed_value ^ expected_compressed_value)) begin
                $display("PASS");
                $display("  Outputs: compressed_value=%h",
                         compressed_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_value=%h",
                         expected_compressed_value);
                $display("  Got:      compressed_value=%h",
                         compressed_value);
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
