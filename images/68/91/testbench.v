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
            in = 8'h00;
            sel = 3'b000;
            data0 = 4'b1010;
            data1 = 4'b0000;
            data2 = 4'b0000;
            data3 = 4'b0000;
            data4 = 4'b0000;
            data5 = 4'b0000;
            #10;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 8'h01;
            sel = 3'b001;
            data1 = 4'b1111;
            #10;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 8'h03;
            sel = 3'b010;
            data2 = 4'b0110;
            #10;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 8'h07;
            sel = 3'b011;
            data3 = 4'b1001;
            #10;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 8'hAA;
            sel = 3'b100;
            data4 = 4'b0101;
            #10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 8'hFF;
            sel = 3'b101;
            data5 = 4'b1110;
            #10;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 3'b000;
            data0 = 4'b1100;
            in = 8'h0F;
            #10;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sel = 3'b001;
            data1 = 4'b1011;
            in = 8'b11100000;
            #10;
            #1;

            check_outputs(4'b1010);
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
