`timescale 1ns/1ps

module png_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] palette_index;
    reg [7:0] pixel_value;
    wire [11:0] compressed_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compressor dut (
        .palette_index(palette_index),
        .pixel_value(pixel_value),
        .compressed_data(compressed_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum values (All zeros)", test_num);
        pixel_value = 8'h00;
        palette_index = 4'h0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (All ones)", test_num);
        pixel_value = 8'hFF;
        palette_index = 4'hF;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical pixel and palette index", test_num);
        pixel_value = 8'hA5;
        palette_index = 4'h3;
        #1;

        check_outputs(12'hA53);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        pixel_value = 8'h55;
        palette_index = 4'hA;
        #1;

        check_outputs(12'h55A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pixel value boundary", test_num);
        pixel_value = 8'h80;
        palette_index = 4'h7;
        #1;

        check_outputs(12'h807);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random selection", test_num);
        pixel_value = 8'hDE;
        palette_index = 4'hB;
        #1;

        check_outputs(12'hDEB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [11:0] expected_compressed_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_data === (expected_compressed_data ^ compressed_data ^ expected_compressed_data)) begin
                $display("PASS");
                $display("  Outputs: compressed_data=%h",
                         compressed_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_data=%h",
                         expected_compressed_data);
                $display("  Got:      compressed_data=%h",
                         compressed_data);
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
