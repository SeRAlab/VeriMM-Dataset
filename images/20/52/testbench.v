`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [3:0] x_frac;
    reg [3:0] y_frac;
    wire [7:0] I_out;

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
        .x_frac(x_frac),
        .y_frac(y_frac),
        .I_out(I_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All pixels same intensity, origin coord", test_num);
        I00 = 8'd128; I01 = 8'd128; I10 = 8'd128; I11 = 8'd128;
        x_frac = 4'd0; y_frac = 4'd0;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Horizontal interpolation (Midpoint)", test_num);
        I00 = 8'd0; I01 = 8'd255; I10 = 8'd0; I11 = 8'd255;
        x_frac = 4'd8; y_frac = 4'd0;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Vertical interpolation (Midpoint)", test_num);
        I00 = 8'd0; I01 = 8'd0; I10 = 8'd255; I11 = 8'd255;
        x_frac = 4'd0; y_frac = 4'd8;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Center point interpolation", test_num);
        I00 = 8'd100; I01 = 8'd200; I10 = 8'd100; I11 = 8'd200;
        x_frac = 4'd8; y_frac = 4'd8;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum fractional coordinates (Near I11)", test_num);
        I00 = 8'd0; I01 = 8'd0; I10 = 8'd0; I11 = 8'd255;
        x_frac = 4'd15; y_frac = 4'd15;

        #1;


        check_outputs(8'd224);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High intensity uniform block", test_num);
        I00 = 8'd255; I01 = 8'd255; I10 = 8'd255; I11 = 8'd255;
        x_frac = 4'd7; y_frac = 4'd3;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed arbitrary values", test_num);
        I00 = 8'd10; I01 = 8'd50; I10 = 8'd100; I11 = 8'd200;
        x_frac = 4'd4; y_frac = 4'd12;



        #1;




        check_outputs(8'd98);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Corner Check (I00)", test_num);
        I00 = 8'd255; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;
        x_frac = 4'd0; y_frac = 4'd0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max X, Min Y", test_num);
        I00 = 8'd0; I01 = 8'd255; I10 = 8'd0; I11 = 8'd0;
        x_frac = 4'd15; y_frac = 4'd0;

        #1;


        check_outputs(8'd239);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero intensity check", test_num);
        I00 = 8'd0; I01 = 8'd0; I10 = 8'd0; I11 = 8'd0;
        x_frac = 4'd10; y_frac = 4'd5;
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
        input [7:0] expected_I_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I_out === (expected_I_out ^ I_out ^ expected_I_out)) begin
                $display("PASS");
                $display("  Outputs: I_out=%h",
                         I_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_out=%h",
                         expected_I_out);
                $display("  Got:      I_out=%h",
                         I_out);
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
