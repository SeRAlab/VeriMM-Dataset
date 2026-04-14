`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in0, in=0x0F (rev upper=0xF), expect in0", test_num);
            in = 8'h0F;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h3; in3 = 4'hC;
            sel = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in1, in=0x0F (rev upper=0xF), expect in1", test_num);
            in = 8'h0F;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h3; in3 = 4'hC;
            sel = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in2, in=0x0F (rev upper=0xF), expect in2", test_num);
            in = 8'h0F;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h3; in3 = 4'hC;
            sel = 2'b10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in3, in=0x0F (rev upper=0xF), expect in3", test_num);
            in = 8'h0F;
            in0 = 4'hA; in1 = 4'h5; in2 = 4'h3; in3 = 4'hC;
            sel = 2'b11;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit Reversal Check - in[0]=1 maps to out[3]", test_num);
            in = 8'b00000001;
            in0 = 4'b1111;
            sel = 2'b00;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit Reversal Check - in[3]=1 maps to out[0]", test_num);
            in = 8'b00001000;
            in0 = 4'b1111;
            sel = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper bits of 'in' (in[7:4]) should be ignored", test_num);
            in = 8'hF0;
            in0 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND masking", test_num);
            in = 8'b00000101;
            in1 = 4'b1100;
            sel = 2'b01;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            in = 8'h00; in0 = 4'h0; in1 = 4'h0; in2 = 4'h0; in3 = 4'h0; sel = 2'b00;
            #1;

            check_outputs(4'h0);
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
