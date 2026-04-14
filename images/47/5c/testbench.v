`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] in_addr;
    reg [3:0] in_data;
    reg [1:0] out_addr;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_addr(in_addr),
        .in_data(in_data),
        .out_addr(out_addr),
        .out_data(out_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Write 4'hA to Index 0 and Read it back");
        in_addr = 2'd0;
        in_data = 4'hA;
        out_addr = 2'd0;
        #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Write 4'h5 to Index 1 and Read it back");
        in_addr = 2'd1;
        in_data = 4'h5;
        out_addr = 2'd1;
        #10;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Write 4'hF to Index 2 and Read it back");
        in_addr = 2'd2;
        in_data = 4'hF;
        out_addr = 2'd2;
        #10;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Read back Index 0 to verify data persistence");
        out_addr = 2'd0;
        #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Overwrite Index 0 with 4'h3 and Read it back");
        in_addr = 2'd0;
        in_data = 4'h3;
        out_addr = 2'd0;
        #10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Read Index 1 to verify it was not affected by Index 0 write");
        out_addr = 2'd1;
        #10;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Write 4'h0 to Index 2 and verify");
        in_addr = 2'd2;
        in_data = 4'h0;
        out_addr = 2'd2;
        #10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Simultaneous write to 1 and read from 0");
        in_addr = 2'd1;
        in_data = 4'hC;
        out_addr = 2'd0;
        #10;
        #1;

        check_outputs(4'h3);
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
        input [3:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
