`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] p00;
    reg [7:0] p01;
    reg [7:0] p10;
    reg [7:0] p11;
    reg [3:0] x_fraction;
    reg [3:0] y_fraction;
    wire [7:0] p_out;

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
        .x_fraction(x_fraction),
        .y_fraction(y_fraction),
        .p_out(p_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniform pixels (128)", test_num);
            p00 = 8'd128; p01 = 8'd128; p10 = 8'd128; p11 = 8'd128;
            x_fraction = 4'd4; y_fraction = 4'd4;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact match top-left (p00)", test_num);
            p00 = 8'd255; p01 = 8'd0; p10 = 8'd0; p11 = 8'd0;
            x_fraction = 4'd0; y_fraction = 4'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal midpoint", test_num);
            p00 = 8'd0; p10 = 8'd255; p01 = 8'd0; p11 = 8'd255;
            x_fraction = 4'd8; y_fraction = 4'd0;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical midpoint", test_num);
            p00 = 8'd0; p01 = 8'd255; p10 = 8'd0; p11 = 8'd255;
            x_fraction = 4'd0; y_fraction = 4'd8;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center of checkerboard", test_num);
            p00 = 8'd0; p10 = 8'd255; p01 = 8'd255; p11 = 8'd0;
            x_fraction = 4'd8; y_fraction = 4'd8;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max fractions (15, 15)", test_num);
            p00 = 8'd10; p10 = 8'd50; p01 = 8'd100; p11 = 8'd200;
            x_fraction = 4'd15; y_fraction = 4'd15;
            #1;

            check_outputs(8'd184);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed values calculation", test_num);
            p00 = 8'd10; p10 = 8'd50; p01 = 8'd100; p11 = 8'd200;
            x_fraction = 4'd4; y_fraction = 4'd12;
            #1;

            check_outputs(8'd98);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            p00 = 8'd0; p10 = 8'd0; p01 = 8'd0; p11 = 8'd0;
            x_fraction = 4'd7; y_fraction = 4'd3;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_p_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_out === (expected_p_out ^ p_out ^ expected_p_out)) begin
                $display("PASS");
                $display("  Outputs: p_out=%h",
                         p_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_out=%h",
                         expected_p_out);
                $display("  Got:      p_out=%h",
                         p_out);
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
