`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Q11;
    reg [7:0] Q12;
    reg [7:0] Q21;
    reg [7:0] Q22;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] P;

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
        .x(x),
        .y(y),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            Q11 = 8'd100; Q21 = 8'd200; Q12 = 8'd50; Q22 = 8'd150;
            x = 8'd0; y = 8'd0;
            #1;

            check_outputs(16'h6400);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            Q11 = 8'd100; Q21 = 8'd200; Q12 = 8'd50; Q22 = 8'd150;
            x = 8'd255; y = 8'd0;
            #1;

            check_outputs(16'hC79C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            Q11 = 8'd100; Q21 = 8'd200; Q12 = 8'd50; Q22 = 8'd150;
            x = 8'd0; y = 8'd255;
            #1;

            check_outputs(16'h3232);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            Q11 = 8'd100; Q21 = 8'd200; Q12 = 8'd50; Q22 = 8'd150;
            x = 8'd128; y = 8'd128;
            #1;

            check_outputs(16'h7D00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            Q11 = 0; Q21 = 0; Q12 = 0; Q22 = 0;
            x = 8'd128; y = 8'd128;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            Q11 = 255; Q21 = 255; Q12 = 255; Q22 = 255;
            x = 8'd255; y = 8'd255;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            Q11 = 8'd0; Q21 = 8'd255; Q12 = 8'd0; Q22 = 8'd255;
            x = 8'd128; y = 8'd0;
            #1;

            check_outputs(16'h7F80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            Q11 = 8'd10; Q21 = 8'd20; Q12 = 8'd30; Q22 = 8'd40;
            x = 8'd64; y = 8'd192;
            #1;

            check_outputs(16'h1B80);
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
        input [15:0] expected_P;
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
