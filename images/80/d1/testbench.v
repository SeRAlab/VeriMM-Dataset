`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg last_in;
    reg ready_out;
    reg reset_in;
    reg [7:0] set_addr_in;
    reg set_strb_in;
    reg valid_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .last_in(last_in),
        .ready_out(ready_out),
        .reset_in(reset_in),
        .set_addr_in(set_addr_in),
        .set_strb_in(set_strb_in),
        .valid_in(valid_in)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset and Initialization...");
            reset_in = 1;
            valid_in = 0;
            data_in = 32'h0;
            last_in = 0;
            set_strb_in = 0;
            set_addr_in = 8'h0;
            ready_out = 1;
            repeat(2) @(posedge clk);
            reset_in = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Basic Data Transfer...");
            reset_in = 1; #10; reset_in = 0;
            @(posedge clk);
            valid_in = 1;
            data_in = 32'hDEADBEEF;
            ready_out = 1;
            @(posedge clk);
            valid_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Configuration Strobe...");
            reset_in = 1; #10; reset_in = 0;
            @(posedge clk);
            set_addr_in = 8'hA5;
            set_strb_in = 1;
            data_in = 32'h12345678;
            @(posedge clk);
            set_strb_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: End of Frame (last_in)...");
            reset_in = 1; #10; reset_in = 0;
            @(posedge clk);
            valid_in = 1;
            data_in = 32'hCAFEFACE;
            last_in = 1;
            @(posedge clk);
            valid_in = 0;
            last_in = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Multi-Cycle Data Burst...");
            reset_in = 1; #10; reset_in = 0;
            @(posedge clk);
            valid_in = 1;
            data_in = 32'h1; @(posedge clk);
            data_in = 32'h2; @(posedge clk);
            data_in = 32'h3;
            last_in = 1;
            @(posedge clk);
            valid_in = 0;
            last_in = 0;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
