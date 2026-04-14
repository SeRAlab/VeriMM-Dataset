`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] sel;
    wire c;
    wire v;
    wire [7:0] y;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .c(c),
        .v(v),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (Basic)", test_num);
            sel = 3'd0; a = 8'h05; b = 8'h0A;

            #1;


            check_outputs(1'b0, 1'b0, 8'h0F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition (Carry Out)", test_num);
            sel = 3'd0; a = 8'hFF; b = 8'h01;

            #1;


            check_outputs(1'b1, 1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition (Signed Overflow)", test_num);
            sel = 3'd0; a = 8'h7F; b = 8'h01;

            #1;


            check_outputs(1'b0, 1'b1, 8'h80, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction (Basic)", test_num);
            sel = 3'd1; a = 8'h14; b = 8'h04;

            #1;


            check_outputs(1'b0, 1'b0, 8'h10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Subtraction (Borrow/Carry)", test_num);
            sel = 3'd1; a = 8'h05; b = 8'h0A;

            #1;


            check_outputs(1'b1, 1'b0, 8'hFB, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtraction (Signed Overflow)", test_num);
            sel = 3'd1; a = 8'h80; b = 8'h01;

            #1;


            check_outputs(1'b0, 1'b1, 8'h7F, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Logical AND", test_num);
            sel = 3'd2; a = 8'hF0; b = 8'hCC;

            #1;


            check_outputs(1'b0, 1'b0, 8'hC0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Logical OR", test_num);
            sel = 3'd3; a = 8'hF0; b = 8'hCC;

            #1;


            check_outputs(1'b0, 1'b0, 8'hFC, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Logical XOR", test_num);
            sel = 3'd4; a = 8'hAA; b = 8'h55;

            #1;


            check_outputs(1'b0, 1'b0, 8'hFF, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Negation (NOT A)", test_num);
            sel = 3'd5; a = 8'hF0; b = 8'h00;

            #1;


            check_outputs(1'b0, 1'b0, 8'h0F, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Constant Zero Output", test_num);
            sel = 3'd6; a = 8'hFF; b = 8'hFF;

            #1;


            check_outputs(1'b0, 1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Constant FF Output", test_num);
            sel = 3'd7; a = 8'h00; b = 8'h00;

            #1;


            check_outputs(1'b0, 1'b0, 8'hFF, 1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_c;
        input expected_v;
        input [7:0] expected_y;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_v === (expected_v ^ v ^ expected_v) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: c=%b, v=%b, y=%h, z=%b",
                         c, v, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, v=%b, y=%h, z=%b",
                         expected_c, expected_v, expected_y, expected_z);
                $display("  Got:      c=%b, v=%b, y=%h, z=%b",
                         c, v, y, z);
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
