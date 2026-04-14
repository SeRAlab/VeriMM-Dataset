`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w_enable;
    reg [7:0] w_mux_in_0;
    reg [7:0] w_mux_in_1;
    reg [7:0] w_mux_in_2;
    reg [7:0] w_mux_in_3;
    wire [7:0] w_mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_enable(w_enable),
        .w_mux_in_0(w_mux_in_0),
        .w_mux_in_1(w_mux_in_1),
        .w_mux_in_2(w_mux_in_2),
        .w_mux_in_3(w_mux_in_3),
        .w_mux_out(w_mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        w_enable = 1'b0;
        w_mux_in_0 = 8'hAA;
        w_mux_in_1 = 8'h55;
        w_mux_in_2 = 8'hFF;
        w_mux_in_3 = 8'h12;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        w_enable = 1'b1;
        w_mux_in_0 = 8'hA5;
        w_mux_in_1 = 8'h00;
        w_mux_in_2 = 8'h00;
        w_mux_in_3 = 8'h00;
        #10;


        #1;



        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        w_enable = 1'b1;
        w_mux_in_0 = 8'h00;
        w_mux_in_1 = 8'h5A;
        w_mux_in_2 = 8'h00;
        w_mux_in_3 = 8'h00;
        #10;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        w_enable = 1'b1;
        w_mux_in_0 = 8'h00;
        w_mux_in_1 = 8'h00;
        w_mux_in_2 = 8'hF0;
        w_mux_in_3 = 8'h00;
        #10;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        w_enable = 1'b1;
        w_mux_in_0 = 8'h00;
        w_mux_in_1 = 8'h00;
        w_mux_in_2 = 8'h00;
        w_mux_in_3 = 8'h0F;
        #10;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        w_enable = 1'b1;
        w_mux_in_0 = 8'h01;
        w_mux_in_1 = 8'h02;
        w_mux_in_2 = 8'h04;
        w_mux_in_3 = 8'h08;
        #10;


        #1;



        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        w_enable = 1'b1;
        w_mux_in_0 = 8'h80;
        w_mux_in_1 = 8'h40;
        w_mux_in_2 = 8'h20;
        w_mux_in_3 = 8'h10;
        #10;
        #1;

        check_outputs(8'hF0);
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
        input [7:0] expected_w_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w_mux_out === (expected_w_mux_out ^ w_mux_out ^ expected_w_mux_out)) begin
                $display("PASS");
                $display("  Outputs: w_mux_out=%h",
                         w_mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w_mux_out=%h",
                         expected_w_mux_out);
                $display("  Got:      w_mux_out=%h",
                         w_mux_out);
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
