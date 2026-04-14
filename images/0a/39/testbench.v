`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [7:0] frac_x;
    reg [7:0] frac_y;
    wire [7:0] I_interp;

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
        .frac_x(frac_x),
        .frac_y(frac_y),
        .I_interp(I_interp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Left Corner", test_num);
            I00 = 8'h10; I01 = 8'h20;
            I10 = 8'h30; I11 = 8'h40;
            frac_x = 8'h00; frac_y = 8'h00;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Right Corner", test_num);
            I00 = 8'h10; I01 = 8'h20;
            I10 = 8'h30; I11 = 8'h40;
            frac_x = 8'hFF; frac_y = 8'h00;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Left Corner", test_num);
            I00 = 8'h10; I01 = 8'h20;
            I10 = 8'h30; I11 = 8'h40;
            frac_x = 8'h00; frac_y = 8'hFF;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bottom-Right Corner", test_num);
            I00 = 8'h10; I01 = 8'h20;
            I10 = 8'h30; I11 = 8'h40;
            frac_x = 8'hFF; frac_y = 8'hFF;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Midpoint", test_num);
            I00 = 8'd0;   I01 = 8'd200;
            I10 = 8'd0;   I11 = 8'd200;
            frac_x = 8'h80;
            frac_y = 8'h00;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Midpoint", test_num);
            I00 = 8'd0;   I01 = 8'd0;
            I10 = 8'd200; I11 = 8'd200;
            frac_x = 8'h00;
            frac_y = 8'h80;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center Point", test_num);

            I00 = 8'd0;   I01 = 8'd100;
            I10 = 8'd100; I11 = 8'd200;
            frac_x = 8'h80;
            frac_y = 8'h80;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniform Area", test_num);
            I00 = 8'd123; I01 = 8'd123;
            I10 = 8'd123; I11 = 8'd123;
            frac_x = 8'h4A;
            frac_y = 8'hBC;
            #1;

            check_outputs(8'd123);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Scale Interpolation", test_num);
            I00 = 8'd0;   I01 = 8'd255;
            I10 = 8'd255; I11 = 8'd0;
            frac_x = 8'h80;
            frac_y = 8'h80;

            #1;


            check_outputs(8'd127);
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
        input [7:0] expected_I_interp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_I_interp === (expected_I_interp ^ I_interp ^ expected_I_interp)) begin
                $display("PASS");
                $display("  Outputs: I_interp=%h",
                         I_interp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: I_interp=%h",
                         expected_I_interp);
                $display("  Got:      I_interp=%h",
                         I_interp);
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
