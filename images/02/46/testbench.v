`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Q11;
    reg [7:0] Q12;
    reg [7:0] Q21;
    reg [7:0] Q22;
    reg [7:0] u;
    reg [7:0] v;
    wire [15:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .Q11(Q11),
        .Q12(Q12),
        .Q21(Q21),
        .Q22(Q22),
        .u(u),
        .v(v),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero", test_num);
            Q11 = 8'd0; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd0;
            u = 8'd0; v = 8'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Uniform pixels (100), u=0, v=0 (Corner Q11)", test_num);
            Q11 = 8'd100; Q12 = 8'd100; Q21 = 8'd100; Q22 = 8'd100;
            u = 8'd0; v = 8'd0;

            #1;


            check_outputs(16'h6400);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Center interpolation (u=0.5, v=0.5), Q11=255", test_num);
            Q11 = 8'd255; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd0;
            u = 8'd128; v = 8'd128;


            #1;



            check_outputs(16'h3FC0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Max u (255/256), v=0, Q21=255", test_num);
            Q11 = 8'd0; Q12 = 8'd0; Q21 = 8'd255; Q22 = 8'd0;
            u = 8'd255; v = 8'd0;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Max coefficients, all pixels maxed", test_num);
            Q11 = 8'd255; Q12 = 8'd255; Q21 = 8'd255; Q22 = 8'd255;
            u = 8'd255; v = 8'd255;


            #1;



            check_outputs(16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Horizontal interpolation only (v=0), u=0.5", test_num);
            Q11 = 8'd10; Q12 = 8'd10; Q21 = 8'd20; Q22 = 8'd20;
            u = 8'd128; v = 8'd0;

            #1;


            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed values (Q11=10, Q21=30, Q12=20, Q22=40, u=0.25, v=0.75)", test_num);
            Q11 = 8'd10; Q21 = 8'd30; Q12 = 8'd20; Q22 = 8'd40;
            u = 8'd64; v = 8'd192;



            #1;




            check_outputs(16'h1680);
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
        input [15:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
