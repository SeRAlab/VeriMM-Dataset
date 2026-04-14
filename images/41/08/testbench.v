`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P00;
    reg [7:0] P01;
    reg [7:0] P10;
    reg [7:0] P11;
    reg [15:0] x;
    reg [15:0] y;
    wire [15:0] Pxy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .P00(P00),
        .P01(P01),
        .P10(P10),
        .P11(P11),
        .x(x),
        .y(y),
        .Pxy(Pxy)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Uniform pixels, origin coordinate", test_num);
            P00 = 8'hAA; P10 = 8'hAA; P01 = 8'hAA; P11 = 8'hAA;
            x = 16'h0000; y = 16'h0000;
            #1;

            check_outputs(16'hAA00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: X-axis interpolation (midpoint)", test_num);
            P00 = 8'd0; P10 = 8'd255; P01 = 8'd0; P11 = 8'd255;
            x = 16'h0080; y = 16'h0000;
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Y-axis interpolation (midpoint)", test_num);
            P00 = 8'd0; P10 = 8'd0; P01 = 8'd255; P11 = 8'd255;
            x = 16'h0000; y = 16'h0080;
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Center point with distinct pixels", test_num);
            P00 = 8'd10; P10 = 8'd20; P01 = 8'd30; P11 = 8'd40;
            x = 16'h0080; y = 16'h0080;

            #1;


            check_outputs(16'h1900);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Complex fractional coordinates", test_num);
            P00 = 8'd10; P10 = 8'd50; P01 = 8'd100; P11 = 8'd200;
            x = 16'h0040; y = 16'h00C0;




            #1;





            check_outputs(16'h62C0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Near bottom-right corner (max fractions)", test_num);
            P00 = 8'd0; P10 = 8'd0; P01 = 8'd0; P11 = 8'd255;
            x = 16'h00FF; y = 16'h00FF;

            #1;


            check_outputs(16'hFD02);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum values throughout", test_num);
            P00 = 8'hFF; P10 = 8'hFF; P01 = 8'hFF; P11 = 8'hFF;
            x = 16'hFFFF; y = 16'hFFFF;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Single pixel active, coordinate at opposite corner", test_num);
            P00 = 8'd255; P10 = 8'd0; P01 = 8'd0; P11 = 8'd0;
            x = 16'h00FF; y = 16'h00FF;


            #1;



            check_outputs(16'h0000);
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
        input [15:0] expected_Pxy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Pxy === (expected_Pxy ^ Pxy ^ expected_Pxy)) begin
                $display("PASS");
                $display("  Outputs: Pxy=%h",
                         Pxy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Pxy=%h",
                         expected_Pxy);
                $display("  Got:      Pxy=%h",
                         Pxy);
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
