`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [7:0] frac_x;
    reg [7:0] frac_y;
    wire [15:0] I_out;

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
        .I_out(I_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Top-Left Corner (frac_x=0, frac_y=0)", test_num);
            I00 = 8'h64; I01 = 8'h00; I10 = 8'h00; I11 = 8'h00;
            frac_x = 8'h00; frac_y = 8'h00;

            #1;


            check_outputs(16'h6400);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exact Center (frac_x=0.5, frac_y=0.5)", test_num);
            I00 = 8'd10; I01 = 8'd20; I10 = 8'd30; I11 = 8'd40;
            frac_x = 8'd128; frac_y = 8'd128;

            #1;


            check_outputs(16'h1900);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Near Bottom-Right Corner (frac_x=255, frac_y=255)", test_num);
            I00 = 8'h00; I01 = 8'h00; I10 = 8'h00; I11 = 8'hFF;
            frac_x = 8'hFF; frac_y = 8'hFF;


            #1;



            check_outputs(16'hFD02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniform Grid (All pixels same)", test_num);
            I00 = 8'hAA; I01 = 8'hAA; I10 = 8'hAA; I11 = 8'hAA;
            frac_x = 8'h40; frac_y = 8'h80;

            #1;


            check_outputs(16'hAA00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Midpoint (frac_x=0.5, frac_y=0)", test_num);
            I00 = 8'd100; I01 = 8'd0; I10 = 8'd200; I11 = 8'd0;
            frac_x = 8'd128; frac_y = 8'd0;

            #1;


            check_outputs(16'h9600);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Midpoint (frac_x=0, frac_y=0.5)", test_num);
            I00 = 8'd50; I01 = 8'd150; I10 = 8'd0; I11 = 8'd0;
            frac_x = 8'd0; frac_y = 8'd128;

            #1;


            check_outputs(16'h6400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Interpolation Point", test_num);
            I00 = 8'd10; I01 = 8'd20; I10 = 8'd30; I11 = 8'd40;
            frac_x = 8'h40; frac_y = 8'h80;



            #1;




            check_outputs(16'h1400);
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
        input [15:0] expected_I_out;
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
