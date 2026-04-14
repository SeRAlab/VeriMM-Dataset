`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1_mux3;
    reg [7:0] in2_mux3;
    reg [7:0] in3_mux3;
    reg [7:0] in4_mux3;
    reg [1:0] sel_mux3;
    wire [7:0] o_mux3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1_mux3(in1_mux3),
        .in2_mux3(in2_mux3),
        .in3_mux3(in3_mux3),
        .in4_mux3(in4_mux3),
        .sel_mux3(sel_mux3),
        .o_mux3(o_mux3)
    );
    task testcase001;

        begin
            test_num = 1;
            in1_mux3 = 8'h11;
            in2_mux3 = 8'h22;
            in3_mux3 = 8'h33;
            in4_mux3 = 8'h44;
            sel_mux3 = 2'b00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in1_mux3 = 8'h11;
            in2_mux3 = 8'h22;
            in3_mux3 = 8'h33;
            in4_mux3 = 8'h44;
            sel_mux3 = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in1_mux3 = 8'h11;
            in2_mux3 = 8'h22;
            in3_mux3 = 8'h33;
            in4_mux3 = 8'h44;
            sel_mux3 = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in1_mux3 = 8'h11;
            in2_mux3 = 8'h22;
            in3_mux3 = 8'h33;
            in4_mux3 = 8'h44;
            sel_mux3 = 2'b11;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            in1_mux3 = 8'hFF;
            in2_mux3 = 8'h00;
            in3_mux3 = 8'hAA;
            in4_mux3 = 8'h55;
            sel_mux3 = 2'b00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            in1_mux3 = 8'h0F;
            in2_mux3 = 8'hF0;
            in3_mux3 = 8'hCC;
            in4_mux3 = 8'h55;
            sel_mux3 = 2'b11;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            sel_mux3 = 2'b10;
            in1_mux3 = 8'h01;
            in2_mux3 = 8'h02;
            in3_mux3 = 8'h99;
            in4_mux3 = 8'h04;
            #5;
            in1_mux3 = 8'hFF;
            in4_mux3 = 8'hAA;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_o_mux3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_mux3 === (expected_o_mux3 ^ o_mux3 ^ expected_o_mux3)) begin
                $display("PASS");
                $display("  Outputs: o_mux3=%h",
                         o_mux3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_mux3=%h",
                         expected_o_mux3);
                $display("  Got:      o_mux3=%h",
                         o_mux3);
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
