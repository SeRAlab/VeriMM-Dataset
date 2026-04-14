`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] data_in;
    reg request;
    reg reset;
    reg rw;
    wire [31:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .reset(reset),
        .rw(rw),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            address = 0;
            rw = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Write and Read");
            test_num = 1;
            reset_dut();


            @(posedge clk);
            request = 1; rw = 1; address = 32'h00000010; data_in = 32'hDEADBEEF;
            @(posedge clk);
            request = 0;


            @(posedge clk);
            request = 1; rw = 0; address = 32'h00000010;
            @(posedge clk);
            request = 0;

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Reset Validity Check");
            test_num = 2;
            reset_dut();


            @(posedge clk);
            request = 1; rw = 0; address = 32'h0;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Overwrite Address Check");
            test_num = 3;
            reset_dut();


            @(posedge clk);
            request = 1; rw = 1; address = 32'hA0; data_in = 32'h11111111;
            @(posedge clk);


            request = 1; rw = 1; address = 32'hA0; data_in = 32'h22222222;
            @(posedge clk);


            request = 1; rw = 0; address = 32'hA0;
            @(posedge clk);
            request = 0;

            #1;


            check_outputs(32'h22222222, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Boundary Address Check (4092)");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            request = 1; rw = 1; address = 32'd4092; data_in = 32'h55AA55AA;
            @(posedge clk);


            request = 1; rw = 0; address = 32'd4092;
            @(posedge clk);
            request = 0;

            #1;


            check_outputs(32'h55AA55AA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multiple independent locations");
            test_num = 5;
            reset_dut();


            @(posedge clk);
            request = 1; rw = 1; address = 32'h4; data_in = 32'hAAAAAAAA;
            @(posedge clk);


            request = 1; rw = 1; address = 32'h8; data_in = 32'hBBBBBBBB;
            @(posedge clk);


            request = 1; rw = 0; address = 32'h4;
            @(posedge clk);
            request = 0;

            #1;


            check_outputs(32'hAAAAAAAA, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,address, clk, data_in, request, reset, rw, data_out, valid);
    end

endmodule
