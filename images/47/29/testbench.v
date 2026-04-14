`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg select;
    wire [7:0] out_not;
    wire [3:0] out_xor_bitwise;
    wire out_xor_logical;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .out_not(out_not),
        .out_xor_bitwise(out_xor_bitwise),
        .out_xor_logical(out_xor_logical)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'hA; b = 4'h5; select = 0;
        #1;

        check_outputs(8'h00, 4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'h0; b = 4'h0; select = 1;



        #1;




        check_outputs(8'hFF, 4'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'hF; b = 4'hF; select = 1;



        #1;




        check_outputs(8'h00, 4'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'b1010; b = 4'b0101; select = 1;



        #1;




        check_outputs(8'hA5, 4'hF, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'b0000; b = 4'b0011; select = 1;



        #1;




        check_outputs(8'hCF, 4'h3, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b0111; b = 4'b0000; select = 1;



        #1;




        check_outputs(8'hF8, 4'h7, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'hC; b = 4'h9; select = 1;



        #1;




        check_outputs(8'h63, 4'h5, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'hF; b = 4'hF; select = 0;
        #1;

        check_outputs(8'h00, 4'h0, 1'b0);
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
        input [7:0] expected_out_not;
        input [3:0] expected_out_xor_bitwise;
        input expected_out_xor_logical;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_not === (expected_out_not ^ out_not ^ expected_out_not) &&
                expected_out_xor_bitwise === (expected_out_xor_bitwise ^ out_xor_bitwise ^ expected_out_xor_bitwise) &&
                expected_out_xor_logical === (expected_out_xor_logical ^ out_xor_logical ^ expected_out_xor_logical)) begin
                $display("PASS");
                $display("  Outputs: out_not=%h, out_xor_bitwise=%h, out_xor_logical=%b",
                         out_not, out_xor_bitwise, out_xor_logical);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_not=%h, out_xor_bitwise=%h, out_xor_logical=%b",
                         expected_out_not, expected_out_xor_bitwise, expected_out_xor_logical);
                $display("  Got:      out_not=%h, out_xor_bitwise=%h, out_xor_logical=%b",
                         out_not, out_xor_bitwise, out_xor_logical);
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
