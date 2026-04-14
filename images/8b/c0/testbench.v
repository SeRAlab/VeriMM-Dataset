`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] exp_a;
    reg [7:0] exp_b;
    reg [7:0] exp_c;
    wire ab_req;
    wire [7:0] shamt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .exp_c(exp_c),
        .ab_req(ab_req),
        .shamt(shamt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Normal range positive", test_num);
        exp_a = 8'd10;
        exp_b = 8'd10;
        exp_c = 8'd5;


        #1;



        check_outputs(1'b0, 8'h0F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result zero", test_num);
        exp_a = 8'd20;
        exp_b = 8'd30;
        exp_c = 8'd50;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative result (MSB 1)", test_num);
        exp_a = 8'd5;
        exp_b = 8'd5;
        exp_c = 8'd20;


        #1;



        check_outputs(1'b1, 8'hF6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive result exceeding threshold", test_num);
        exp_a = 8'd25;
        exp_b = 8'd25;
        exp_c = 8'd10;


        #1;



        check_outputs(1'b1, 8'h28);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary value 31", test_num);
        exp_a = 8'd20;
        exp_b = 8'd11;
        exp_c = 8'd0;


        #1;



        check_outputs(1'b0, 8'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary value 32", test_num);
        exp_a = 8'd32;
        exp_b = 8'd0;
        exp_c = 8'd0;


        #1;



        check_outputs(1'b1, 8'h20);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 8-bit wrap around logic", test_num);
        exp_a = 8'hFF;
        exp_b = 8'h02;
        exp_c = 8'h01;

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result 128 (MSB 1)", test_num);
        exp_a = 8'd100;
        exp_b = 8'd30;
        exp_c = 8'd2;


        #1;



        check_outputs(1'b1, 8'h80);
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
        input expected_ab_req;
        input [7:0] expected_shamt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ab_req === (expected_ab_req ^ ab_req ^ expected_ab_req) &&
                expected_shamt === (expected_shamt ^ shamt ^ expected_shamt)) begin
                $display("PASS");
                $display("  Outputs: ab_req=%b, shamt=%h",
                         ab_req, shamt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ab_req=%b, shamt=%h",
                         expected_ab_req, expected_shamt);
                $display("  Got:      ab_req=%b, shamt=%h",
                         ab_req, shamt);
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
