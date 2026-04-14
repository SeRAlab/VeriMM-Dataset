`timescale 1ns/1ps

module png_compression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    wire [2:0] compressed_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compression dut (
        .pixel_value(pixel_value),
        .compressed_value(compressed_value)
    );
    task testcase001;

    begin
        pixel_value = 8'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        pixel_value = 8'd31;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        pixel_value = 8'd32;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        pixel_value = 8'd63;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase005;

    begin
        pixel_value = 8'd80;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase006;

    begin
        pixel_value = 8'd127;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase007;

    begin
        pixel_value = 8'd128;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase008;

    begin
        pixel_value = 8'd175;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase009;

    begin
        pixel_value = 8'd223;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase010;

    begin
        pixel_value = 8'd255;
        #1;

        check_outputs(3'd7);
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
