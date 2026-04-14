`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [3:0] io_in_a;
    reg [3:0] io_in_b;
    reg [3:0] io_in_c;
    reg reset;
    wire [7:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_in_a(io_in_a),
        .io_in_b(io_in_b),
        .io_in_c(io_in_c),
        .reset(reset),
        .io_out(io_out)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        io_in_a = 4'd0; io_in_b = 4'd0; io_in_c = 4'd0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'd2; io_in_b = 4'd3; io_in_c = 4'd4;
        @(posedge clock);

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'hf; io_in_b = 4'hf; io_in_c = 4'hf;
        @(posedge clock);

        #1;


        check_outputs(8'hf0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'd0; io_in_b = 4'd12; io_in_c = 4'd7;
        @(posedge clock);

        #1;


        check_outputs(8'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'd5; io_in_b = 4'd5; io_in_c = 4'd0;
        @(posedge clock);

        #1;


        check_outputs(8'd25);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'd1; io_in_b = 4'd9; io_in_c = 4'd2;
        @(posedge clock);

        #1;


        check_outputs(8'd11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_in_a = 4'd14; io_in_b = 4'd14; io_in_c = 4'd10;
        @(posedge clock);

        #1;


        check_outputs(8'd206);
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
        input [7:0] expected_io_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%h",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%h",
                         expected_io_out);
                $display("  Got:      io_out=%h",
                         io_out);
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
