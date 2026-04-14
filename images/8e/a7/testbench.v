`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk27;
    reg [9:0] current_x;
    reg [9:0] current_y;
    reg ndown;
    reg nleft;
    reg nright;
    reg nup;
    reg rst27;
    wire [3:0] model_b;
    wire [3:0] model_g;
    wire [3:0] model_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk27(clk27),
        .current_x(current_x),
        .current_y(current_y),
        .ndown(ndown),
        .nleft(nleft),
        .nright(nright),
        .nup(nup),
        .rst27(rst27),
        .model_b(model_b),
        .model_g(model_g),
        .model_r(model_r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and check zero value", test_num);
            rst27 = 1;
            current_x = 10'd0;
            current_y = 10'd500;
            nleft = 1; nright = 1; nup = 1; ndown = 1;
            #40;
            rst27 = 0;
            #40;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (x=10)", test_num);
            rst27 = 1; #20; rst27 = 0;
            current_x = 10'd10;
            current_y = 10'd0;
            nleft = 1; nright = 1; nup = 1; ndown = 1;
            #40;
            #1;

            check_outputs(4'hA, 4'hA, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 4-bit value (x=15)", test_num);
            rst27 = 1; #20; rst27 = 0;
            current_x = 10'd15;
            current_y = 10'd1023;
            nleft = 0; nright = 1; nup = 0; ndown = 1;
            #40;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation check (x=10'b11_1111_0101)", test_num);
            rst27 = 1; #20; rst27 = 0;
            current_x = 10'b11_1111_0101;
            current_y = 10'd123;
            nleft = 1; nright = 0; nup = 1; ndown = 0;
            #40;
            #1;

            check_outputs(4'h5, 4'h5, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify independence from Y and movement signals", test_num);
            rst27 = 1; #20; rst27 = 0;
            current_x = 10'd8;
            current_y = 10'd888;
            nleft = 0; nright = 0; nup = 0; ndown = 0;
            #40;
            #1;

            check_outputs(4'h8, 4'h8, 4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_model_b;
        input [3:0] expected_model_g;
        input [3:0] expected_model_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_model_b === (expected_model_b ^ model_b ^ expected_model_b) &&
                expected_model_g === (expected_model_g ^ model_g ^ expected_model_g) &&
                expected_model_r === (expected_model_r ^ model_r ^ expected_model_r)) begin
                $display("PASS");
                $display("  Outputs: model_b=%h, model_g=%h, model_r=%h",
                         model_b, model_g, model_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: model_b=%h, model_g=%h, model_r=%h",
                         expected_model_b, expected_model_g, expected_model_r);
                $display("  Got:      model_b=%h, model_g=%h, model_r=%h",
                         model_b, model_g, model_r);
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
