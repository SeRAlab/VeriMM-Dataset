`timescale 1ns/1ps

module jpeg_dct_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] pixel_values;
    wire [63:0] dct_coefficients;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_dct dut (
        .pixel_values(pixel_values),
        .dct_coefficients(dct_coefficients)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            pixel_values = 64'h0000000000000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            pixel_values = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pixel index 0 set in each row", test_num);
            pixel_values = 64'h0101010101010101;


            #1;



            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pixel index 1 set in each row", test_num);
            pixel_values = 64'h0202020202020202;


            #1;



            check_outputs(64'hB5B5B5B5B5B5B5B5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pixel indices 0 and 1 set in each row", test_num);
            pixel_values = 64'h0303030303030303;



            #1;




            check_outputs(64'h4A4A4A4A4A4A4A4A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pixel index 2 set in each row", test_num);
            pixel_values = 64'h0404040404040404;


            #1;



            check_outputs(64'hB3B3B3B3B3B3B3B3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard row pattern (0xAA)", test_num);
            pixel_values = 64'hAAAAAAAAAAAAAAAA;



            #1;




            check_outputs(64'h0000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_dct Testbench");
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
        input [63:0] expected_dct_coefficients;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dct_coefficients === (expected_dct_coefficients ^ dct_coefficients ^ expected_dct_coefficients)) begin
                $display("PASS");
                $display("  Outputs: dct_coefficients=%h",
                         dct_coefficients);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct_coefficients=%h",
                         expected_dct_coefficients);
                $display("  Got:      dct_coefficients=%h",
                         dct_coefficients);
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
