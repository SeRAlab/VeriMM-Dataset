`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] I;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .I00(I00),
        .I01(I01),
        .I10(I10),
        .I11(I11),
        .x(x),
        .y(y),
        .I(I)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Top-Left Corner (x=0, y=0)", test_num);
            I00 = 8'd200; I01 = 8'd50; I10 = 8'd100; I11 = 8'd150;
            x = 8'd0; y = 8'd0;

            #1;


            check_outputs(16'hC800);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Horizontal Interpolation (y=0, x=0.5)", test_num);
            I00 = 8'd100; I10 = 8'd200; I01 = 8'd0; I11 = 8'd0;
            x = 8'd128; y = 8'd0;

            #1;


            check_outputs(16'h9600);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Vertical Interpolation (x=0, y=0.5)", test_num);
            I00 = 8'd100; I01 = 8'd200; I10 = 8'd0; I11 = 8'd0;
            x = 8'd0; y = 8'd128;

            #1;


            check_outputs(16'h9600);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Center of the Block (x=0.5, y=0.5)", test_num);
            I00 = 8'd0; I10 = 8'd0; I01 = 8'd0; I11 = 8'd255;
            x = 8'd128; y = 8'd128;

            #1;


            check_outputs(16'h3FC0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Uniform Intensity Block", test_num);
            I00 = 8'd100; I10 = 8'd100; I01 = 8'd100; I11 = 8'd100;
            x = 8'd64; y = 8'd192;

            #1;


            check_outputs(16'h6400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Maximum Coordinates (x=255, y=255)", test_num);
            I00 = 8'd0; I10 = 8'd0; I01 = 8'd0; I11 = 8'd255;
            x = 8'd255; y = 8'd255;

            #1;


            check_outputs(16'hFCFB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Full Scale Gradient", test_num);
            I00 = 8'd0; I10 = 8'd255; I01 = 8'd255; I11 = 8'd0;
            x = 8'd128; y = 8'd128;

            #1;


            check_outputs(16'h7F80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Near Top-Right Edge", test_num);
            I00 = 8'd0; I10 = 8'd255; I01 = 8'd0; I11 = 8'd0;
            x = 8'd255; y = 8'd0;

            #1;


            check_outputs(16'hFE01);
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
        input [15:0] expected_I;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I === (expected_I ^ I ^ expected_I)) begin
                $display("PASS");
                $display("  Outputs: I=%h",
                         I);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I=%h",
                         expected_I);
                $display("  Got:      I=%h",
                         I);
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
