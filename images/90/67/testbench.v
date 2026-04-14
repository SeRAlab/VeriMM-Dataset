`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg SEL;
    reg [15:0] in;
    wire [7:0] OR_output;
    wire Y;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .in(in),
        .OR_output(OR_output),
        .Y(Y),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            in = 16'h0000;
            SEL = 0;
            A = 0;
            B = 0;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SEL=0, Select A=1", test_num);
            in = 16'hAA55;
            SEL = 0;
            A = 1;
            B = 0;


            #1;



            check_outputs(8'hFF, 1'b1, 8'hAA, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SEL=1, Select B=1", test_num);
            in = 16'hF00F;
            SEL = 1;
            A = 0;
            B = 1;


            #1;



            check_outputs(8'hFF, 1'b1, 8'hF0, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR check with Y=0", test_num);
            in = 16'h1234;
            SEL = 0;
            A = 0;
            B = 1;


            #1;



            check_outputs(8'h36, 1'b0, 8'h12, 8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            in = 16'hFFFF;
            SEL = 1;
            A = 1;
            B = 1;

            #1;


            check_outputs(8'hFF, 1'b1, 8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mux SEL=0 logic check", test_num);
            in = 16'h0000;
            SEL = 0;
            A = 1;
            B = 0;

            #1;


            check_outputs(8'h01, 1'b1, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mux SEL=1 logic check", test_num);
            in = 16'h0000;
            SEL = 1;
            A = 1;
            B = 0;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High/Low separation check", test_num);
            in = 16'hABCD;
            SEL = 0;
            A = 0;
            B = 0;


            #1;



            check_outputs(8'hEB, 1'b0, 8'hAB, 8'hCD);
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
        input [7:0] expected_OR_output;
        input expected_Y;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OR_output === (expected_OR_output ^ OR_output ^ expected_OR_output) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: OR_output=%h, Y=%b, out_hi=%h, out_lo=%h",
                         OR_output, Y, out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OR_output=%h, Y=%b, out_hi=%h, out_lo=%h",
                         expected_OR_output, expected_Y, expected_out_hi, expected_out_lo);
                $display("  Got:      OR_output=%h, Y=%b, out_hi=%h, out_lo=%h",
                         OR_output, Y, out_hi, out_lo);
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
