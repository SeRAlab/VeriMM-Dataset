`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg [3:0] data1_0;
    reg [3:0] data1_1;
    reg [3:0] data1_2;
    reg [3:0] data1_3;
    reg [3:0] data1_4;
    reg [3:0] data1_5;
    reg [3:0] data2_0;
    reg [3:0] data2_1;
    reg [1:0] sel1;
    reg [1:0] sel2;
    wire out_wire;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .data1_0(data1_0),
        .data1_1(data1_1),
        .data1_2(data1_2),
        .data1_3(data1_3),
        .data1_4(data1_4),
        .data1_5(data1_5),
        .data2_0(data2_0),
        .data2_1(data2_1),
        .sel1(sel1),
        .sel2(sel2),
        .out_wire(out_wire)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR basic logic - 0 ^ 0", test_num);
            a = 0;
            b = 0;
            sel1 = 2'b00;
            sel2 = 2'b00;
            data1_0 = 4'h0; data1_1 = 4'h0; data1_2 = 4'h0; data1_3 = 4'h0;
            data1_4 = 4'h0; data1_5 = 4'h0;
            data2_0 = 4'h0; data2_1 = 4'h0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR basic logic - 0 ^ 1", test_num);
            a = 0;
            b = 1;
            sel1 = 2'b01;
            sel2 = 2'b01;
            data1_0 = 4'h1; data1_1 = 4'h2; data1_2 = 4'h3; data1_3 = 4'h4;
            data1_4 = 4'h5; data1_5 = 4'h6;
            data2_0 = 4'h7; data2_1 = 4'h8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR basic logic - 1 ^ 0", test_num);
            a = 1;
            b = 0;
            sel1 = 2'b10;
            sel2 = 2'b10;
            data1_0 = 4'hF; data1_1 = 4'hE; data1_2 = 4'hD; data1_3 = 4'hC;
            data1_4 = 4'hB; data1_5 = 4'hA;
            data2_0 = 4'h9; data2_1 = 4'h8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: XOR basic logic - 1 ^ 1", test_num);
            a = 1;
            b = 1;
            sel1 = 2'b11;
            sel2 = 2'b11;
            data1_0 = 4'hA; data1_1 = 4'hB; data1_2 = 4'hC; data1_3 = 4'hD;
            data1_4 = 4'hE; data1_5 = 4'hF;
            data2_0 = 4'h1; data2_1 = 4'h2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify XOR output remains stable while varying other inputs", test_num);
            a = 1;
            b = 0;

            sel1 = 2'b00; sel2 = 2'b11;
            #5;
            sel1 = 2'b11; sel2 = 2'b00;
            #5;
            data1_0 = 4'h5; data2_0 = 4'hA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comprehensive data signal noise check", test_num);
            a = 0;
            b = 1;
            data1_0 = 4'hF; data1_1 = 4'hF; data1_2 = 4'hF; data1_3 = 4'hF;
            data1_4 = 4'hF; data1_5 = 4'hF;
            data2_0 = 4'hF; data2_1 = 4'hF;
            sel1 = 2'b10;
            sel2 = 2'b01;
            #1;

            check_outputs(1'b1);
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
        input expected_out_wire;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_wire === (expected_out_wire ^ out_wire ^ expected_out_wire)) begin
                $display("PASS");
                $display("  Outputs: out_wire=%b",
                         out_wire);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_wire=%b",
                         expected_out_wire);
                $display("  Got:      out_wire=%b",
                         out_wire);
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
