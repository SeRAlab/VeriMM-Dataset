`timescale 1ns/1ps

module png_interlacing_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_interlacing dut (
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Zeros", test_num);
        pixel_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Ones", test_num);
        pixel_in = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Alternating Bits AA", test_num);
        pixel_in = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Alternating Bits 55", test_num);
        pixel_in = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Upper Nibble High", test_num);
        pixel_in = 8'hF0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Lower Nibble High", test_num);
        pixel_in = 8'h0F;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Random Pattern A5", test_num);
        pixel_in = 8'hA5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Walking Bit (MSB)", test_num);
        pixel_in = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Walking Bit (LSB)", test_num);
        pixel_in = 8'h01;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Mid-range value", test_num);
        pixel_in = 8'h7F;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_interlacing Testbench");
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
