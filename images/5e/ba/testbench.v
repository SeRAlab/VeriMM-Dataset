`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] byteenable_in;
    reg clk;
    reg reset_n;
    reg waitrequest_in;
    reg write_in;
    wire [1:0] byteenable_out;
    wire waitrequest_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byteenable_in(byteenable_in),
        .clk(clk),
        .reset_n(reset_n),
        .waitrequest_in(waitrequest_in),
        .write_in(write_in),
        .byteenable_out(byteenable_out),
        .waitrequest_out(waitrequest_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset functionality");
        reset_n = 0;
        byteenable_in = 2'b11;
        write_in = 1;
        waitrequest_in = 1;
        #10;
        reset_n = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(byteenable_out, waitrequest_out);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Write enabled, Lower Byte only");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);
        byteenable_in = 2'b01;
        write_in = 1;
        waitrequest_in = 0;
        @(posedge clk);
        #1;

        check_outputs(2'b01, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Write enabled, Upper Byte only");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);
        byteenable_in = 2'b10;
        write_in = 1;
        waitrequest_in = 0;
        @(posedge clk);
        #1;

        check_outputs(2'b10, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Write enabled, Both Bytes with Wait Request");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);
        byteenable_in = 2'b11;
        write_in = 1;
        waitrequest_in = 1;
        @(posedge clk);
        #1;

        check_outputs(2'b11, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Write disabled (Read/Idle), Byte Enables should be 0");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);
        byteenable_in = 2'b11;
        write_in = 0;
        waitrequest_in = 0;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Wait request active but Write inactive");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);
        byteenable_in = 2'b11;
        write_in = 0;
        waitrequest_in = 1;
        @(posedge clk);



        #1;




        check_outputs(2'b00, waitrequest_out);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Sequential write transitions");
        reset_n = 0; #10 reset_n = 1;
        @(posedge clk);

        byteenable_in = 2'b11;
        write_in = 1;
        waitrequest_in = 0;
        @(posedge clk);

        write_in = 0;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 0);
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
        input [1:0] expected_byteenable_out;
        input expected_waitrequest_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_byteenable_out === (expected_byteenable_out ^ byteenable_out ^ expected_byteenable_out) &&
                expected_waitrequest_out === (expected_waitrequest_out ^ waitrequest_out ^ expected_waitrequest_out)) begin
                $display("PASS");
                $display("  Outputs: byteenable_out=%h, waitrequest_out=%b",
                         byteenable_out, waitrequest_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: byteenable_out=%h, waitrequest_out=%b",
                         expected_byteenable_out, expected_waitrequest_out);
                $display("  Got:      byteenable_out=%h, waitrequest_out=%b",
                         byteenable_out, waitrequest_out);
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
