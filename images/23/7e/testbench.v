`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] p00;
    reg [7:0] p01;
    reg [7:0] p10;
    reg [7:0] p11;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .p00(p00),
        .p01(p01),
        .p10(p10),
        .p11(p11),
        .x(x),
        .y(y),
        .pixel_out(pixel_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Left Corner (x=0, y=0)", test_num);

            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;

            p00 = 8'hAA; p10 = 8'hBB; p01 = 8'hCC; p11 = 8'hDD;
            x = 8'd0;
            y = 8'd0;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Right Corner (x=255, y=0)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'hAA; p10 = 8'hBB; p01 = 8'hCC; p11 = 8'hDD;
            x = 8'd255;
            y = 8'd0;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Left Corner (x=0, y=255)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'hAA; p10 = 8'hBB; p01 = 8'hCC; p11 = 8'hDD;
            x = 8'd0;
            y = 8'd255;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Right Corner (x=255, y=255)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'hAA; p10 = 8'hBB; p01 = 8'hCC; p11 = 8'hDD;
            x = 8'd255;
            y = 8'd255;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniformity Test (Full White)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'd255; p10 = 8'd255; p01 = 8'd255; p11 = 8'd255;
            x = 8'd128;
            y = 8'd128;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniformity Test (Full Black)", test_num);
            p00 = 8'd255; p01 = 8'd255; p10 = 8'd255; p11 = 8'd255; x = 8'd255; y = 8'd255;
            p00 = 8'd0; p10 = 8'd0; p01 = 8'd0; p11 = 8'd0;
            x = 8'd64;
            y = 8'd192;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Midpoint (x=128, y=0)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'd100; p10 = 8'd200; p01 = 8'd100; p11 = 8'd200;
            x = 8'd128;
            y = 8'd0;

            #1;


            check_outputs(8'd150);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Midpoint (x=0, y=128)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'd50; p10 = 8'd50; p01 = 8'd150; p11 = 8'd150;
            x = 8'd0;
            y = 8'd128;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center Average (x=128, y=128)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'd0; p10 = 8'd200; p01 = 8'd200; p11 = 8'd0;
            x = 8'd128;
            y = 8'd128;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Contrast Ramp (x=128, y=255)", test_num);
            p00 = 8'd0; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0; x = 8'd0; y = 8'd0;
            p00 = 8'd0; p10 = 8'd0; p01 = 8'd0; p11 = 8'd255;
            x = 8'd128;
            y = 8'd255;

            #1;


            check_outputs(8'd128);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interpolation Testbench");
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
