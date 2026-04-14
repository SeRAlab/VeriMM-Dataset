`timescale 1ns/1ps

module png_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pixel_data;
    wire [255:0] rle_data;
    wire [7:0] rle_length;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_compressor dut (
        .pixel_data(pixel_data),
        .rle_data(rle_data),
        .rle_length(rle_length)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All four pixels identical (AAAA)", test_num);
        pixel_data = 32'hAAAAAAAA;

        #1;


        check_outputs({16'h04AA, 240'h0}, 8'd16);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: All four pixels different (ABCD)", test_num);
        pixel_data = 32'h11223344;

        #1;


        check_outputs({64'h0111012201330144, 192'h0}, 8'd64);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Two pairs (AABB)", test_num);
        pixel_data = 32'h55556666;

        #1;


        check_outputs({32'h02550266, 224'h0}, 8'd32);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Three same, one different (AAAB)", test_num);
        pixel_data = 32'h77777788;

        #1;


        check_outputs({32'h03770188, 224'h0}, 8'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: One different, three same (ABBB)", test_num);
        pixel_data = 32'h99AAAAAA;

        #1;


        check_outputs({32'h019903AA, 224'h0}, 8'd32);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Two same, two different (AABC)", test_num);
        pixel_data = 32'hBBBBCCDD;

        #1;


        check_outputs({48'h02BB01CC01DD, 208'h0}, 8'd48);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: One different, two same, one different (ABBC)", test_num);
        pixel_data = 32'hEEFFFF11;

        #1;


        check_outputs({48'h01EE02FF0111, 208'h0}, 8'd48);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Two different, two same (ABCC)", test_num);
        pixel_data = 32'h12345555;

        #1;


        check_outputs({48'h011201340255, 208'h0}, 8'd48);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Repeated but non-adjacent (ABBA)", test_num);
        pixel_data = 32'h11222211;


        #1;



        check_outputs({48'h011102220111, 208'h0}, 8'd48);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: All zeros", test_num);
        pixel_data = 32'h00000000;

        #1;


        check_outputs({16'h0400, 240'h0}, 8'd16);
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
        input [255:0] expected_rle_data;
        input [7:0] expected_rle_length;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rle_data === (expected_rle_data ^ rle_data ^ expected_rle_data) &&
                expected_rle_length === (expected_rle_length ^ rle_length ^ expected_rle_length)) begin
                $display("PASS");
                $display("  Outputs: rle_data=%h, rle_length=%h",
                         rle_data, rle_length);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rle_data=%h, rle_length=%h",
                         expected_rle_data, expected_rle_length);
                $display("  Got:      rle_data=%h, rle_length=%h",
                         rle_data, rle_length);
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
