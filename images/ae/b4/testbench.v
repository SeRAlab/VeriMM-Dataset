`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [1:0] sel;
    wire [7:0] out_and_bitwise;
    wire [7:0] out_nor_bitwise;
    wire [15:0] out_not;
    wire [7:0] out_xor_bitwise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out_and_bitwise(out_and_bitwise),
        .out_nor_bitwise(out_nor_bitwise),
        .out_not(out_not),
        .out_xor_bitwise(out_xor_bitwise)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 8'hAA; in1 = 8'h55; in2 = 8'hCC; in3 = 8'h33; sel = 2'b00;




            #1;





            check_outputs(8'h00, 8'h00, 16'hFF55, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 8'hAA; in1 = 8'h55; in2 = 8'hCC; in3 = 8'h33; sel = 2'b01;

            #1;


            check_outputs(8'h00, 8'h00, 16'hFFAA, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 8'hF0; in1 = 8'h0F; in2 = 8'h81; in3 = 8'h18; sel = 2'b10;




            #1;





            check_outputs(8'h00, 8'h00, 16'hFF7E, 8'h99);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'h00; in3 = 8'hA5; sel = 2'b11;




            #1;





            check_outputs(8'hFF, 8'h00, 16'hFF5A, 8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00; sel = 2'b00;




            #1;





            check_outputs(8'h00, 8'hFF, 16'hFFFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 8'hF0; in1 = 8'hF0; in2 = 8'h12; in3 = 8'h34; sel = 2'b10;




            #1;





            check_outputs(8'hF0, 8'h0F, 16'hFFED, 8'h26);
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
        input [7:0] expected_out_and_bitwise;
        input [7:0] expected_out_nor_bitwise;
        input [15:0] expected_out_not;
        input [7:0] expected_out_xor_bitwise;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and_bitwise === (expected_out_and_bitwise ^ out_and_bitwise ^ expected_out_and_bitwise) &&
                expected_out_nor_bitwise === (expected_out_nor_bitwise ^ out_nor_bitwise ^ expected_out_nor_bitwise) &&
                expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor_bitwise === (expected_out_xor_bitwise ^ out_xor_bitwise ^ expected_out_xor_bitwise)) begin
                $display("PASS");
                $display("  Outputs: out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor_bitwise=%h",
                         out_and_bitwise, out_nor_bitwise, out_not, out_xor_bitwise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor_bitwise=%h",
                         expected_out_and_bitwise, expected_out_nor_bitwise, expected_out_not, expected_out_xor_bitwise);
                $display("  Got:      out_and_bitwise=%h, out_nor_bitwise=%h, out_not=%h, out_xor_bitwise=%h",
                         out_and_bitwise, out_nor_bitwise, out_not, out_xor_bitwise);
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
