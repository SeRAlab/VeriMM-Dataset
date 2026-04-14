`timescale 1ns/1ps

module polynomial_evaluator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] a2;
    reg [7:0] a3;
    reg [7:0] a4;
    reg [7:0] x;
    wire [31:0] result;

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
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            a4 = 8'd0; a3 = 8'd0; a2 = 8'd0; a1 = 8'd0; a0 = 8'd0; x = 8'd10;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Constant polynomial (only a0)", test_num);
            a4 = 8'd0; a3 = 8'd0; a2 = 8'd0; a1 = 8'd0; a0 = 8'd255; x = 8'd255;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x = 0 (Result should be a0)", test_num);
            a4 = 8'd10; a3 = 8'd20; a2 = 8'd30; a1 = 8'd40; a0 = 8'd50; x = 8'd0;
            #1;

            check_outputs(32'h00000032);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x = 1 (Result should be sum of coefficients)", test_num);
            a4 = 8'd10; a3 = 8'd20; a2 = 8'd30; a1 = 8'd40; a0 = 8'd50; x = 8'd1;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Linear polynomial evaluation", test_num);
            a4 = 8'd0; a3 = 8'd0; a2 = 8'd0; a1 = 8'd5; a0 = 8'd10; x = 8'd10;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Quadratic polynomial evaluation", test_num);
            a4 = 8'd0; a3 = 8'd0; a2 = 8'd5; a1 = 8'd0; a0 = 8'd0; x = 8'd10;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cubic polynomial evaluation", test_num);
            a4 = 8'd0; a3 = 8'd5; a2 = 8'd0; a1 = 8'd0; a0 = 8'd0; x = 8'd10;
            #1;

            check_outputs(32'd5000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Quartic term evaluation", test_num);
            a4 = 8'd5; a3 = 8'd0; a2 = 8'd0; a1 = 8'd0; a0 = 8'd0; x = 8'd10;
            #1;

            check_outputs(32'd50000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed coefficients, small x", test_num);
            a4 = 8'd1; a3 = 8'd2; a2 = 8'd3; a1 = 8'd4; a0 = 8'd5; x = 8'd2;

            #1;


            check_outputs(32'd57);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (32-bit truncation check)", test_num);
            a4 = 8'hFF; a3 = 8'hFF; a2 = 8'hFF; a1 = 8'hFF; a0 = 8'hFF; x = 8'hFF;


            #1;



            check_outputs(32'h070333A5);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
