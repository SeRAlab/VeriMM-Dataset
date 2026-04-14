`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg [1023:0] in;
    reg [7:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .in(in),
        .sel(sel),
        .out(out)
    );
    task clear_in;

        begin
            in = {32{32'h00000000}};
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 0; b = 0; c = 0;
            sel = 8'd0;
            in[3:0] = 4'b0010;
            $display("Test %0d: Decoder(000) + MUX(sel 0, val 2)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 0; b = 0; c = 1;
            sel = 8'd5;
            in[5*4 +: 4] = 4'b0101;
            $display("Test %0d: Decoder(001) + MUX(sel 5, val 5)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 0; b = 1; c = 0;
            sel = 8'd128;
            in[128*4 +: 4] = 4'b0011;
            $display("Test %0d: Decoder(010) + MUX(sel 128, val 3)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 0; b = 1; c = 1;
            sel = 8'd255;
            in[255*4 +: 4] = 4'b0001;
            $display("Test %0d: Decoder(011) + MUX(sel 255, val 1)", test_num);
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 1; b = 0; c = 0;
            sel = 8'd10;
            in[10*4 +: 4] = 4'b1100;
            $display("Test %0d: Decoder(100) + MUX(sel 10, val 12)", test_num);
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 0; b = 1; c = 1;
            sel = 8'd20;
            in[20*4 +: 4] = 4'b1001;
            $display("Test %0d: Overflow Test (8 + 9 = 17 mod 16)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            clear_in();
            a = 1; b = 1; c = 1;
            sel = 8'd64;
            in[64*4 +: 4] = 4'b1111;
            $display("Test %0d: Decoder(111) + MUX(sel 64, val 15)", test_num);
            #1;

            check_outputs(4'd15);
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
