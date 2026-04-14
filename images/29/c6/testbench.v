`timescale 1ns/1ps

module BilinearInterpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Q11;
    reg [7:0] Q12;
    reg [7:0] Q21;
    reg [7:0] Q22;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BilinearInterpolation dut (
        .Q11(Q11),
        .Q12(Q12),
        .Q21(Q21),
        .Q22(Q22),
        .x(x),
        .y(y),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Q11 (x=0, y=0)", test_num);
            Q11 = 8'hAA; Q21 = 8'h55; Q12 = 8'h33; Q22 = 8'hCC;
            x = 8'h00; y = 8'h00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Q21 (x=255, y=0)", test_num);
            Q11 = 8'hAA; Q21 = 8'h55; Q12 = 8'h33; Q22 = 8'hCC;
            x = 8'hFF; y = 8'h00;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Q12 (x=0, y=255)", test_num);
            Q11 = 8'hAA; Q21 = 8'h55; Q12 = 8'h33; Q22 = 8'hCC;
            x = 8'h00; y = 8'hFF;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Q22 (x=255, y=255)", test_num);
            Q11 = 8'hAA; Q21 = 8'h55; Q12 = 8'h33; Q22 = 8'hCC;
            x = 8'hFF; y = 8'hFF;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform color field", test_num);
            Q11 = 8'h77; Q21 = 8'h77; Q12 = 8'h77; Q22 = 8'h77;
            x = 8'h40; y = 8'hC0;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Interpolation on X-axis (y=0, x=128)", test_num);
            Q11 = 8'd0; Q21 = 8'd255; Q12 = 8'd0; Q22 = 8'd255;
            x = 8'd128; y = 8'd0;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Interpolation on Y-axis (x=0, y=128)", test_num);
            Q11 = 8'd100; Q21 = 8'd0; Q12 = 8'd200; Q22 = 8'd0;
            x = 8'd0; y = 8'd128;

            #1;


            check_outputs(8'h96);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Center interpolation (x=128, y=128)", test_num);
            Q11 = 8'd0; Q21 = 8'd255; Q12 = 8'd255; Q22 = 8'd0;
            x = 8'd128; y = 8'd128;


            #1;



            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values", test_num);
            Q11 = 8'hFF; Q21 = 8'hFF; Q12 = 8'hFF; Q22 = 8'hFF;
            x = 8'h80; y = 8'h80;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zero values", test_num);
            Q11 = 8'h00; Q21 = 8'h00; Q12 = 8'h00; Q22 = 8'h00;
            x = 8'hFF; y = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BilinearInterpolation Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
