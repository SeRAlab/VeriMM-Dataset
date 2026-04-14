`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] encoded_value_in;
    reg [7:0] prob;
    reg [7:0] sym;
    wire [7:0] decoded_sym;
    wire [31:0] encoded_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .encoded_value_in(encoded_value_in),
        .prob(prob),
        .sym(sym),
        .decoded_sym(decoded_sym),
        .encoded_value(encoded_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic small values", test_num);
        sym = 8'd5;
        prob = 8'd10;

        encoded_value_in = 32'd50;
        #1;

        check_outputs(8'd5, 32'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Lower bound (sym=0)", test_num);
        sym = 8'd0;
        prob = 8'd25;

        encoded_value_in = 32'd0;
        #1;

        check_outputs(8'd0, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Max symbol value", test_num);
        sym = 8'd255;
        prob = 8'd2;

        encoded_value_in = 32'd510;
        #1;

        check_outputs(8'd255, 32'd510);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Mid-range values", test_num);
        sym = 8'd100;
        prob = 8'd40;

        encoded_value_in = 32'd4000;
        #1;

        check_outputs(8'd100, 32'd4000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max probability", test_num);
        sym = 8'd10;
        prob = 8'd255;

        encoded_value_in = 32'd2550;
        #1;

        check_outputs(8'd10, 32'd2550);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Large range product", test_num);
        sym = 8'd200;
        prob = 8'd200;

        encoded_value_in = 32'd40000;
        #1;

        check_outputs(8'd200, 32'd40000);
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
        input [7:0] expected_decoded_sym;
        input [31:0] expected_encoded_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoded_sym === (expected_decoded_sym ^ decoded_sym ^ expected_decoded_sym) &&
                expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value)) begin
                $display("PASS");
                $display("  Outputs: decoded_sym=%h, encoded_value=%h",
                         decoded_sym, encoded_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_sym=%h, encoded_value=%h",
                         expected_decoded_sym, expected_encoded_value);
                $display("  Got:      decoded_sym=%h, encoded_value=%h",
                         decoded_sym, encoded_value);
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
