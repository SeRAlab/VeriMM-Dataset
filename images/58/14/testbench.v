`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [2:0] pri;
    wire [2:0] en;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .pri(pri),
        .en(en),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No inputs active", test_num);
        in = 4'b0000;
        pri = 3'b000;
        #1;

        check_outputs(3'b000, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single input - bit 0", test_num);
        in = 4'b0001;
        pri = 3'b111;
        #1;

        check_outputs(3'b111, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single input - bit 2", test_num);
        in = 4'b0100;
        pri = 3'b101;
        #1;

        check_outputs(3'b101, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single input - bit 3", test_num);
        in = 4'b1000;
        pri = 3'b011;
        #1;

        check_outputs(3'b011, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Competition - bits 0 and 1 active", test_num);
        in = 4'b0011;
        pri = 3'b111;

        #1;


        check_outputs(3'b111, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Competition - bits 0, 1, and 3 active", test_num);
        in = 4'b1011;
        pri = 3'b110;

        #1;


        check_outputs(3'b110, 2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs active", test_num);
        in = 4'b1111;
        pri = 3'b100;

        #1;


        check_outputs(3'b100, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority mask change with constant input", test_num);
        in = 4'b0110;
        pri = 3'b010;

        #1;


        check_outputs(3'b010, 2'b10);
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
        input [2:0] expected_en;
        input [1:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en === (expected_en ^ en ^ expected_en) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: en=%h, out=%h",
                         en, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en=%h, out=%h",
                         expected_en, expected_out);
                $display("  Got:      en=%h, out=%h",
                         en, out);
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
