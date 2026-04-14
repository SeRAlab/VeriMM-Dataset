`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] enable;
    reg [7:0] in;
    reg [2047:0] mux_in;
    reg [7:0] sel;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in(in),
        .mux_in(mux_in),
        .sel(sel),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .pos(pos)
    );
    task setup_mux;

        begin
            for (i = 0; i < 256; i = i + 1) begin
                mux_in[i*8 +: 8] = i[7:0];
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            in = 8'b1000_0000;
            sel = 8'd10;
            enable = 2'b00;

            #1;


            check_outputs(8'd10, 8'h00, 8'h00, 8'h00, 3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 8'b0000_0001;
            sel = 8'd20;
            enable = 2'b01;

            #1;


            check_outputs(8'h00, 8'd20, 8'h00, 8'h00, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 8'b0001_0000;
            sel = 8'd30;
            enable = 2'b10;

            #1;


            check_outputs(8'h00, 8'h00, 8'd30, 8'h00, 3'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 8'b0110_1100;
            sel = 8'd40;
            enable = 2'b11;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'd40, 3'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 8'b0000_0100;
            sel = 8'd0;
            enable = 2'b00;

            #1;


            check_outputs(8'd0, 8'h00, 8'h00, 8'h00, 3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 8'b0000_1000;
            sel = 8'd255;
            enable = 2'b01;

            #1;


            check_outputs(8'h00, 8'd255, 8'h00, 8'h00, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 8'b0000_0000;
            sel = 8'd100;
            enable = 2'b10;


            #1;



            check_outputs(8'h00, 8'h00, 8'd100, 8'h00, 3'd0);
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        input [2:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h, pos=%h",
                         out1, out2, out3, out4, pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h, pos=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4, expected_pos);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h, pos=%h",
                         out1, out2, out3, out4, pos);
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
