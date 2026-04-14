`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] e;
    wire [7:0] f;
    wire [7:0] g;
    wire [7:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            a = 8'h01; b = 8'h00; c = 8'h00; d = 8'h01;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Determinant Zero", test_num);
            a = 8'h04; b = 8'h04; c = 8'h02; d = 8'h02;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Det=1, negative results for f and g", test_num);
            a = 8'h03; b = 8'h02; c = 8'h01; d = 8'h01;
            #1;

            check_outputs(8'h01, 8'hFE, 8'hFF, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Det=-1, negative results for e and h", test_num);
            a = 8'h01; b = 8'h02; c = 8'h01; d = 8'h01;
            #1;

            check_outputs(8'hFF, 8'h02, 8'h01, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Det=-4, integer division results", test_num);
            a = 8'h04; b = 8'h08; c = 8'h01; d = 8'h01;
            #1;

            check_outputs(8'h00, 8'h02, 8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unit Determinant symmetric", test_num);
            a = 8'h05; b = 8'h02; c = 8'h02; d = 8'h01;
            #1;

            check_outputs(8'h01, 8'hFE, 8'hFE, 8'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation to Zero", test_num);
            a = 8'h0A; b = 8'h00; c = 8'h00; d = 8'h0A;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Matrix (Singular)", test_num);
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [7:0] expected_e;
        input [7:0] expected_f;
        input [7:0] expected_g;
        input [7:0] expected_h;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: e=%h, f=%h, g=%h, h=%h",
                         e, f, g, h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h, f=%h, g=%h, h=%h",
                         expected_e, expected_f, expected_g, expected_h);
                $display("  Got:      e=%h, f=%h, g=%h, h=%h",
                         e, f, g, h);
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
