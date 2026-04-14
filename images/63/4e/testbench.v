`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg add_en;
    reg carry_in;
    reg sub_en;
    wire carry_out;
    wire [7:0] data_out;
    wire out_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .add_en(add_en),
        .carry_in(carry_in),
        .sub_en(sub_en),
        .carry_out(carry_out),
        .data_out(data_out),
        .out_en(out_en)
    );
    task testcase001;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd15; B = 8'd25; add_en = 1; sub_en = 0; carry_in = 0;
        #1;

        check_outputs(1'b0, 8'd40, 1'b1);
    end
        endtask

    task testcase002;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd10; B = 8'd20; add_en = 1; sub_en = 0; carry_in = 1;
        #1;

        check_outputs(1'b0, 8'd31, 1'b1);
    end
        endtask

    task testcase003;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd200; B = 8'd100; add_en = 1; sub_en = 0; carry_in = 0;
        #1;

        check_outputs(1'b1, 8'd44, 1'b1);
    end
        endtask

    task testcase004;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd100; B = 8'd40; add_en = 0; sub_en = 1; carry_in = 0;

        #1;


        check_outputs(1'b0, 8'd60, 1'b1);
    end
        endtask

    task testcase005;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd40; B = 8'd100; add_en = 0; sub_en = 1; carry_in = 0;

        #1;


        check_outputs(1'b1, 8'd196, 1'b1);
    end
        endtask

    task testcase006;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'd127; B = 8'd127; add_en = 0; sub_en = 1; carry_in = 0;
        #1;

        check_outputs(1'b0, 8'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'hFF; B = 8'hFF; add_en = 0; sub_en = 0;
        #1;

        check_outputs(carry_out, data_out, 1'b0);
    end
        endtask

    task testcase008;

    begin

        A = 0; B = 0; add_en = 0; sub_en = 0; carry_in = 0;
        #10;

        A = 8'hFF; B = 8'hFF; add_en = 1; sub_en = 0; carry_in = 1;
        #1;

        check_outputs(1'b1, 8'hFF, 1'b1);
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
        input expected_carry_out;
        input [7:0] expected_data_out;
        input expected_out_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_out_en === (expected_out_en ^ out_en ^ expected_out_en)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, data_out=%h, out_en=%b",
                         carry_out, data_out, out_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, data_out=%h, out_en=%b",
                         expected_carry_out, expected_data_out, expected_out_en);
                $display("  Got:      carry_out=%b, data_out=%h, out_en=%b",
                         carry_out, data_out, out_en);
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
