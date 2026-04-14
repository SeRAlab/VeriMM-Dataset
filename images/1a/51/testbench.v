`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P11;
    reg [7:0] P12;
    reg [7:0] P21;
    reg [7:0] P22;
    reg [7:0] fx;
    reg [7:0] fy;
    wire [7:0] Pout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .P11(P11),
        .P12(P12),
        .P21(P21),
        .P22(P22),
        .fx(fx),
        .fy(fy),
        .Pout(Pout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Top-Left Corner", test_num);
            P11 = 8'd50;  P12 = 8'd100;
            P21 = 8'd150; P22 = 8'd200;
            fx = 8'd0;    fy = 8'd0;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Top-Right Corner", test_num);
            P11 = 8'd50;  P12 = 8'd100;
            P21 = 8'd150; P22 = 8'd200;
            fx = 8'd255;  fy = 8'd0;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bottom-Left Corner", test_num);
            P11 = 8'd50;  P12 = 8'd100;
            P21 = 8'd150; P22 = 8'd200;
            fx = 8'd0;    fy = 8'd255;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bottom-Right Corner", test_num);
            P11 = 8'd50;  P12 = 8'd100;
            P21 = 8'd150; P22 = 8'd200;
            fx = 8'd255;  fy = 8'd255;
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Pixel Block", test_num);
            P11 = 8'd128; P12 = 8'd128;
            P21 = 8'd128; P22 = 8'd128;
            fx = 8'd127;  fy = 8'd64;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Midpoint", test_num);
            P11 = 8'd0;   P12 = 8'd255;
            P21 = 8'd0;   P22 = 8'd255;
            fx = 8'd128;  fy = 8'd128;

            #1;


            check_outputs(8'd127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Only", test_num);
            P11 = 8'd0;   P12 = 8'd200;
            P21 = 8'd50;  P22 = 8'd50;
            fx = 8'd128;  fy = 8'd0;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Only", test_num);
            P11 = 8'd10;  P12 = 8'd80;
            P21 = 8'd110; P22 = 8'd200;
            fx = 8'd0;    fy = 8'd128;

            #1;


            check_outputs(8'd60);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Min-Max Gradient", test_num);
            P11 = 8'd0;   P12 = 8'd255;
            P21 = 8'd255; P22 = 8'd0;
            fx = 8'd128;  fy = 8'd128;

            #1;


            check_outputs(8'd127);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Black Block", test_num);
            P11 = 8'd0;   P12 = 8'd0;
            P21 = 8'd0;   P22 = 8'd0;
            fx = 8'd200;  fy = 8'd150;
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
        input [7:0] expected_Pout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Pout === (expected_Pout ^ Pout ^ expected_Pout)) begin
                $display("PASS");
                $display("  Outputs: Pout=%h",
                         Pout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Pout=%h",
                         expected_Pout);
                $display("  Got:      Pout=%h",
                         Pout);
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
