`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P00;
    reg [7:0] P01;
    reg [7:0] P10;
    reg [7:0] P11;
    reg [7:0] u;
    reg [7:0] v;
    wire [15:0] P_out;

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
        .u(u),
        .v(v),
        .P_out(P_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P01 = 8'h00; P10 = 8'h00; P11 = 8'h00;
            u = 8'h00; v = 8'h00;
            #10;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            P00 = 8'hFF; P01 = 8'h00; P10 = 8'h00; P11 = 8'h00;
            u = 8'h00; v = 8'h00;
            #10;
            $display("Test %0d: Origin (P00)", test_num);
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P01 = 8'h00; P10 = 8'hFF; P11 = 8'h00;
            u = 8'hFF; v = 8'h00;
            #10;
            $display("Test %0d: u=Max, v=0 (Near P10)", test_num);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P01 = 8'hFF; P10 = 8'h00; P11 = 8'h00;
            u = 8'h00; v = 8'hFF;
            #10;
            $display("Test %0d: u=0, v=Max (Near P01)", test_num);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P01 = 8'h00; P10 = 8'h00; P11 = 8'hFF;
            u = 8'hFF; v = 8'hFF;
            #10;
            $display("Test %0d: u=Max, v=Max (Near P11)", test_num);
            #1;

            check_outputs(16'hFD02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            P00 = 8'h64; P01 = 8'h64; P10 = 8'h64; P11 = 8'h64;
            u = 8'h80; v = 8'h80;
            #10;
            $display("Test %0d: Uniform Pixels (100)", test_num);
            #1;

            check_outputs(16'h6400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P10 = 8'hFF; P01 = 8'h00; P11 = 8'hFF;
            u = 8'h80; v = 8'h00;
            #10;
            $display("Test %0d: Horizontal Midpoint", test_num);
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            P00 = 8'h00; P10 = 8'h00; P01 = 8'hFF; P11 = 8'hFF;
            u = 8'h00; v = 8'h80;
            #10;
            $display("Test %0d: Vertical Midpoint", test_num);
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            P00 = 8'd10; P10 = 8'd30; P01 = 8'd20; P11 = 8'd40;
            u = 8'h80; v = 8'h80;
            #10;
            $display("Test %0d: Center Average", test_num);

            #1;


            check_outputs(16'h1900);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            P00 = 8'hFF; P01 = 8'hFF; P10 = 8'hFF; P11 = 8'hFF;
            u = 8'h80; v = 8'h80;
            #10;
            $display("Test %0d: Full Scale Uniform", test_num);
            #1;

            check_outputs(16'hFF00);
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
        input [15:0] expected_P_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P_out === (expected_P_out ^ P_out ^ expected_P_out)) begin
                $display("PASS");
                $display("  Outputs: P_out=%h",
                         P_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P_out=%h",
                         expected_P_out);
                $display("  Got:      P_out=%h",
                         P_out);
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
