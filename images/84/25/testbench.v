`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg io;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .io(io),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        io = 0;
        data_in = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        io = 1;
        data_in = 32'h0000_0000;
        #1;

        check_outputs(32'd31);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        io = 0;
        data_in = 32'h0000_0001;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        io = 0;
        data_in = 32'h8000_0000;
        #1;

        check_outputs(32'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        io = 0;
        data_in = 32'h0001_0000;
        #1;

        check_outputs(32'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        io = 0;
        data_in = 32'h0000_0100;
        #1;

        check_outputs(32'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        io = 0;
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'd31);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        io = 1;
        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        io = 0;
        data_in = 32'h0000_000F;
        #1;

        check_outputs(32'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        io = 1;
        data_in = 32'hF000_0000;
        #1;

        check_outputs(32'd27);
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
        testcase010();
        
        
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
