`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [7:0] in;
    reg [2:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 8'b00000001;
        sel = 3'd0;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (1 bit), Sel 0", test_num);
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 8'b00001000;
        sel = 3'd1;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (1 bit), Sel 1", test_num);
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 8'b00010110;
        sel = 3'd2;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (3 bits), Sel 2", test_num);
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 8'b01111111;
        sel = 3'd3;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (7 bits), Sel 3", test_num);
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 8'b10000000;
        sel = 3'd4;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (1 bit), Sel 4", test_num);
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 8'b11111110;
        sel = 3'd5;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC; data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        $display("Test %0d: Parity Odd (7 bits), Sel 5", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 8'b00000000;
        sel = 3'd0;
        data0 = 4'hA;
        $display("Test %0d: Parity Even (0 bits), Sel 0", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 8'b00000011;
        sel = 3'd3;
        data3 = 4'hD;
        $display("Test %0d: Parity Even (2 bits), Sel 3", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 8'b11111111;
        sel = 3'd5;
        data5 = 4'hF;
        $display("Test %0d: Parity Even (8 bits), Sel 5", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 8'b10101010;
        sel = 3'd2;
        data2 = 4'hC;
        $display("Test %0d: Parity Even (4 bits), Sel 2", test_num);
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
