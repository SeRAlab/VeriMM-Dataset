`timescale 1ns/1ps

module jpeg_dct_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] pixel_block;
    wire [127:0] dct_coeffs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_dct dut (
        .pixel_block(pixel_block),
        .dct_coeffs(dct_coeffs)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Black Block", test_num);
        pixel_block = 64'h0000_0000_0000_0000;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Uniform White Block", test_num);
        pixel_block = 64'hFFFF_FFFF_FFFF_FFFF;

        #1;


        check_outputs(128'hF0000000000000000000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Uniform Mid-Gray Block", test_num);
        pixel_block = 64'h8888_8888_8888_8888;
        #1;

        check_outputs(128'h80000000000000000000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Horizontal Gradient", test_num);

        pixel_block = 64'h0123_0123_0123_0123;

        #1;


        check_outputs(128'h18000500000000000000000000000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Vertical Split Block", test_num);

        pixel_block = 64'h00FF_00FF_00FF_00FF;
        #1;

        check_outputs(128'h78000F00000000000000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Checkerboard Pattern", test_num);
        pixel_block = 64'hF0F0_0F0F_F0F0_0F0F;
        #1;

        check_outputs(128'h780000000000000000000000000000FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Pixel Impulse", test_num);
        pixel_block = 64'hF000_0000_0000_0000;
        #1;

        check_outputs(128'h0F010101010101010101010101010101);
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
        input [127:0] expected_dct_coeffs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dct_coeffs === (expected_dct_coeffs ^ dct_coeffs ^ expected_dct_coeffs)) begin
                $display("PASS");
                $display("  Outputs: dct_coeffs=%h",
                         dct_coeffs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct_coeffs=%h",
                         expected_dct_coeffs);
                $display("  Got:      dct_coeffs=%h",
                         dct_coeffs);
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
