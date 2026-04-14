`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    reg [1:0] shift_amount;
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
        .sel(sel),
        .shift_amount(shift_amount),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            data0 = 4'b1011; data1 = 4'h0; data2 = 4'h0;
            data3 = 4'h0;    data4 = 4'h0; data5 = 4'h0;
            sel = 3'd0;
            shift_amount = 2'd0;
            $display("Test %0d: sel=0, shift=0", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data0 = 4'h0;    data1 = 4'b1110; data2 = 4'h0;
            data3 = 4'h0;    data4 = 4'h0;    data5 = 4'h0;
            sel = 3'd1;
            shift_amount = 2'd0;
            $display("Test %0d: sel=1, shift=0", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data2 = 4'b1100;
            sel = 3'd2;
            shift_amount = 2'd1;
            $display("Test %0d: sel=2, shift=1", test_num);

            #1;


            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data3 = 4'b1011;
            sel = 3'd3;
            shift_amount = 2'd2;
            $display("Test %0d: sel=3, shift=2", test_num);

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data4 = 4'hA;
            sel = 3'd4;
            shift_amount = 2'd0;
            $display("Test %0d: sel=4, shift=0", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data5 = 4'b1111;
            sel = 3'd5;
            shift_amount = 2'd3;
            $display("Test %0d: sel=5, shift=3", test_num);

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data0 = 4'h1; data1 = 4'h2; data2 = 4'h3;
            data3 = 4'h4; data4 = 4'h5; data5 = 4'h6;
            sel = 3'd6;
            shift_amount = 2'd0;
            $display("Test %0d: sel=6 (out of range), shift=0", test_num);

            #1;


            check_outputs(out);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data1 = 4'b1001;
            sel = 3'd1;
            shift_amount = 2'd1;
            $display("Test %0d: sel=1, shift=1 (Verify lower bits)", test_num);

            #1;


            check_outputs(4'b0100);
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
