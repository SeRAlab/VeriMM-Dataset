`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr_in;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;
    wire wp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .data_in(data_in),
        .we(we),
        .data_out(data_out),
        .wp(wp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pass-through Mode (we=0)", test_num);
        we = 1'b0;
        addr_in = 4'h5;
        data_in = 8'hAA;
        #1;

        check_outputs(8'hAA, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Normal Write - Unprotected Address", test_num);
        we = 1'b1;
        addr_in = 4'h8;
        data_in = 8'hBB;
        #1;

        check_outputs(8'hBB, 1'b0);
    end
        endtask

    task testcase003;

    reg [7:0] prev_data;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Write Protection - Protected Address", test_num);


        we = 1'b0;
        addr_in = 4'h0;
        data_in = 8'h11;
        #1;
        prev_data = data_out;


        we = 1'b1;
        data_in = 8'hEE;


        #1;



        check_outputs(prev_data, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Protection Recovery", test_num);


        we = 1'b1;
        addr_in = 4'h0;
        data_in = 8'hFF;
        #5;


        we = 1'b0;
        data_in = 8'hCC;
        #1;

        check_outputs(8'hCC, 1'b0);
    end
        endtask

    task testcase005;

    reg [7:0] base_val;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Check - Address 0xF", test_num);

        we = 1'b0;
        addr_in = 4'hF;
        data_in = 8'h55;
        #1;
        base_val = data_out;

        we = 1'b1;
        data_in = 8'h99;


        #1;



        check_outputs(base_val, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_wp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_wp === (expected_wp ^ wp ^ expected_wp)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, wp=%b",
                         data_out, wp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, wp=%b",
                         expected_data_out, expected_wp);
                $display("  Got:      data_out=%h, wp=%b",
                         data_out, wp);
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
