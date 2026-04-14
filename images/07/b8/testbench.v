`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] x_frac;
    reg [7:0] y_frac;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .x_frac(x_frac),
        .y_frac(y_frac),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
            x_frac = 8'h00; y_frac = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Max Value", test_num);
            A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF;
            x_frac = 8'h80; y_frac = 8'h80;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Corner A", test_num);
            A = 8'd10; B = 8'd20; C = 8'd30; D = 8'd40;
            x_frac = 8'h00; y_frac = 8'h00;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near Corner B", test_num);
            A = 8'd10; B = 8'd210; C = 8'd10; D = 8'd210;
            x_frac = 8'hFF; y_frac = 8'h00;
            #1;

            check_outputs(8'd209);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near Corner C", test_num);
            A = 8'd10; B = 8'd10; C = 8'd210; D = 8'd210;
            x_frac = 8'h00; y_frac = 8'hFF;
            #1;

            check_outputs(8'd209);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Near Corner D", test_num);
            A = 8'd50; B = 8'd50; C = 8'd50; D = 8'd250;
            x_frac = 8'hFF; y_frac = 8'hFF;
            #1;

            check_outputs(8'd248);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Midpoint", test_num);
            A = 8'd0; B = 8'd200; C = 8'd0; D = 8'd200;
            x_frac = 8'h80;
            y_frac = 8'h00;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Midpoint", test_num);
            A = 8'd0; B = 8'd0; C = 8'd100; D = 8'd100;
            x_frac = 8'h00;
            y_frac = 8'h80;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Point", test_num);
            A = 8'h00; B = 8'hFF; C = 8'hFF; D = 8'h00;
            x_frac = 8'h80; y_frac = 8'h80;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Gradient Midpoint", test_num);
            A = 8'd0; B = 8'd100; C = 8'd200; D = 8'd255;
            x_frac = 8'h80; y_frac = 8'h80;
            #1;

            check_outputs(8'd138);
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
        input [7:0] expected_interpolated_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_pixel === (expected_interpolated_pixel ^ interpolated_pixel ^ expected_interpolated_pixel)) begin
                $display("PASS");
                $display("  Outputs: interpolated_pixel=%h",
                         interpolated_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_pixel=%h",
                         expected_interpolated_pixel);
                $display("  Got:      interpolated_pixel=%h",
                         interpolated_pixel);
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
