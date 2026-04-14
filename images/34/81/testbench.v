`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] a2;
    reg [7:0] a3;
    reg [7:0] a4;
    reg [3:0] x;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    polynomial_evaluator dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .x(x),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            a0 = 8'h00; a1 = 8'h00; a2 = 8'h00; a3 = 8'h00; a4 = 8'h00; x = 4'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x=0, check a0", test_num);
            a0 = 8'hFF; a1 = 8'h05; a2 = 8'h10; a3 = 8'h02; a4 = 8'h01; x = 4'h0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear term only", test_num);
            a0 = 8'h00; a1 = 8'h0A; a2 = 8'h00; a3 = 8'h00; a4 = 8'h00; x = 4'h5;
            #1;

            check_outputs(16'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple coefficients, x=1", test_num);
            a0 = 8'd1; a1 = 8'd1; a2 = 8'd1; a3 = 8'd1; a4 = 8'd1; x = 4'h1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Quadratic expression", test_num);
            a0 = 8'd10; a1 = 8'd5; a2 = 8'd2; a3 = 8'd0; a4 = 8'd0; x = 4'd3;

            #1;


            check_outputs(16'd43);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of x^4", test_num);
            a0 = 8'd0; a1 = 8'd0; a2 = 8'd0; a3 = 8'd0; a4 = 8'd1; x = 4'd8;

            #1;


            check_outputs(16'h1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horner method check (mixed)", test_num);
            a0 = 8'd1; a1 = 8'd1; a2 = 8'd1; a3 = 8'd2; a4 = 8'd1; x = 4'd2;

            #1;


            check_outputs(16'd39);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High value P(x) within 16-bit range", test_num);
            a0 = 8'd255; a1 = 8'd0; a2 = 8'd0; a3 = 8'd0; a4 = 8'd1; x = 4'd15;

            #1;


            check_outputs(16'd50880);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow handling (16-bit truncation)", test_num);
            a0 = 8'd0; a1 = 8'd0; a2 = 8'd0; a3 = 8'd0; a4 = 8'd10; x = 4'd10;


            #1;



            check_outputs(16'h86A0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max overflow check", test_num);
            a0 = 8'd255; a1 = 8'd255; a2 = 8'd255; a3 = 8'd255; a4 = 8'd255; x = 4'd15;


            #1;



            check_outputs(16'h0AFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("polynomial_evaluator Testbench");
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
