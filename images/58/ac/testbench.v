`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [15:0] in;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [2:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .shift_out(shift_out)
    );
    task clear_shift_reg;

        begin
            in = 16'h0000;
            repeat(3) begin
                #10 enable = 1;
                #10 enable = 0;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Basic Byte Splitting and SR Reset");
            test_num = 1;
            enable = 0;
            in = 16'hABCD;


            clear_shift_reg();



            #1;




            check_outputs(8'hAB, 8'hCD, 3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift in a '1'");
            test_num = 2;
            clear_shift_reg();

            in = 16'h0001;
            #10 enable = 1;
            #10 enable = 0;


            #1;



            check_outputs(8'h00, 8'h01, 3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sequence of shifts (101)");
            test_num = 3;
            clear_shift_reg();


            in = 16'h0001;
            #10 enable = 1; #10 enable = 0;


            in = 16'h0000;
            #10 enable = 1; #10 enable = 0;


            in = 16'h0001;
            #10 enable = 1; #10 enable = 0;


            #1;



            check_outputs(8'h00, 8'h01, 3'b101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Combinational logic vs Sequential logic");
            test_num = 4;
            clear_shift_reg();


            in = 16'h0001;
            #10 enable = 1; #10 enable = 0;
            in = 16'h0001;
            #10 enable = 1; #10 enable = 0;


            in = 16'hF0F0;
            #10;
            #1;

            check_outputs(8'hF0, 8'hF0, 3'b011);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Register Overflow (4 bits shifted into 3-bit SR)");
            test_num = 5;
            clear_shift_reg();


            in = 16'h0001; #10 enable = 1; #10 enable = 0;
            in = 16'h0001; #10 enable = 1; #10 enable = 0;
            in = 16'h0000; #10 enable = 1; #10 enable = 0;
            in = 16'h0001; #10 enable = 1; #10 enable = 0;

            #1;


            check_outputs(8'h00, 8'h01, 3'b101);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Fast input changes");
            test_num = 6;
            clear_shift_reg();

            in = 16'h1234;
            #5 enable = 1;
            in = 16'h5678;
            #5 enable = 0;




            #1;





            check_outputs(8'h56, 8'h78, 3'b000);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [2:0] expected_shift_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h, shift_out=%h",
                         out_hi, out_lo, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h, shift_out=%h",
                         expected_out_hi, expected_out_lo, expected_shift_out);
                $display("  Got:      out_hi=%h, out_lo=%h, shift_out=%h",
                         out_hi, out_lo, shift_out);
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
