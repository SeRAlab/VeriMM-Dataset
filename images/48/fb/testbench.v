`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [55:0] in;
    reg [2:0] select;
    wire a;
    wire [3:0] b;
    wire [1:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .select(select),
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select Index 0 with pattern 7'b1_1010_01", test_num);
            in = 56'h0;
            in[6:0] = 7'b1_1010_01;
            select = 3'd0;
            #1;

            check_outputs(1'b1, 4'b1010, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select Index 7 with pattern 7'b0_1111_11", test_num);
            in = 56'h0;
            in[55:49] = 7'b0_1111_11;
            select = 3'd7;
            #1;

            check_outputs(1'b0, 4'b1111, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select Index 3 with pattern 7'b1_0000_10", test_num);
            in = 56'h0;
            in[27:21] = 7'b1_0000_10;
            select = 3'd3;
            #1;

            check_outputs(1'b1, 4'b0000, 2'b10);
        end
        endtask

    task testcase004;

        integer i;
        reg [6:0] test_val;
        begin
            test_num = 4;
            $display("Test %0d: Exhaustive check of all indices with unique patterns", test_num);


            for (i = 0; i < 8; i = i + 1) begin
                test_val = {i[0], (i[3:0] + 4'd1), i[2:1]};
                in[i*7 +: 7] = test_val;
            end

            for (i = 0; i < 8; i = i + 1) begin
                select = i;
                test_val = in[i*7 +: 7];
                #1;

                check_outputs(test_val[6], test_val[5:2], test_val[1:0]);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Boundary conditions (All Zeros)", test_num);
            in = 56'h00000000000000;
            select = 3'd4;
            #1;

            check_outputs(1'b0, 4'h0, 2'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Boundary conditions (All Ones)", test_num);
            in = 56'hFFFFFFFFFFFFFF;
            select = 3'd2;
            #1;

            check_outputs(1'b1, 4'hF, 2'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Dynamic switching of select signal", test_num);
            in = {7'h01, 7'h12, 7'h23, 7'h34, 7'h45, 7'h56, 7'h67, 7'h78};

            select = 3'd0;
            #1;

            check_outputs(1'b1, 4'b1110, 2'b00);


            select = 3'd5;
            #1;

            check_outputs(1'b0, 4'b1000, 2'b11);
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
        input expected_a;
        input [3:0] expected_b;
        input [1:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%h, c=%h",
                         a, b, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%h, c=%h",
                         expected_a, expected_b, expected_c);
                $display("  Got:      a=%b, b=%h, c=%h",
                         a, b, c);
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
