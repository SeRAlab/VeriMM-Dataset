`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] P11;
    reg [7:0] P12;
    reg [7:0] P21;
    reg [7:0] P22;
    reg [7:0] u;
    reg [7:0] v;
    wire [7:0] P_out;

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
        .u(u),
        .v(v),
        .P_out(P_out)
    );
    task testcase001;

        begin
            P11 = 8'd0; P12 = 8'd0; P21 = 8'd0; P22 = 8'd0;
            u = 8'd0; v = 8'd0;
            $display("Testcase 001: All Zeros");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            P11 = 8'd100; P12 = 8'd200; P21 = 8'd50; P22 = 8'd150;
            u = 8'd0; v = 8'd0;
            $display("Testcase 002: Top-Left Corner (u=0, v=0)");
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            P11 = 8'd100; P12 = 8'd200; P21 = 8'd50; P22 = 8'd150;
            u = 8'd128; v = 8'd128;
            $display("Testcase 003: Center Point (u=0.5, v=0.5)");

            #1;


            check_outputs(8'd125);
        end
        endtask

    task testcase004;

        begin
            P11 = 8'd255; P12 = 8'd255; P21 = 8'd255; P22 = 8'd255;
            u = 8'd64; v = 8'd192;
            $display("Testcase 004: Uniform Field (All 255)");
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            P11 = 8'd100; P12 = 8'd200; P21 = 8'd50; P22 = 8'd150;
            u = 8'd128; v = 8'd0;
            $display("Testcase 005: Horizontal Interpolation (v=0)");

            #1;


            check_outputs(8'd150);
        end
        endtask

    task testcase006;

        begin
            P11 = 8'd100; P12 = 8'd200; P21 = 8'd50; P22 = 8'd150;
            u = 8'd0; v = 8'd128;
            $display("Testcase 006: Vertical Interpolation (u=0)");

            #1;


            check_outputs(8'd75);
        end
        endtask

    task testcase007;

        begin
            P11 = 8'd0; P12 = 8'd0; P21 = 8'd0; P22 = 8'd200;
            u = 8'd255; v = 8'd255;
            $display("Testcase 007: Near Bottom-Right Corner (u=255, v=255)");

            #1;


            check_outputs(8'd198);
        end
        endtask

    task testcase008;

        begin
            P11 = 8'd50; P12 = 8'd150; P21 = 8'd200; P22 = 8'd10;
            u = 8'd64; v = 8'd192;
            $display("Testcase 008: General Interpolation");





            #1;






            check_outputs(8'd133);
        end
        endtask

    task testcase009;

        begin
            P11 = 8'd255; P12 = 8'd0; P21 = 8'd0; P22 = 8'd0;
            u = 8'd255; v = 8'd0;
            $display("Testcase 009: High Gradient (u max, v 0)");

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
        input [7:0] expected_P_out;
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
