`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] mem_readdata;
    reg [1:0] mem_readdataid;
    reg mem_waitrequest;
    reg reset;
    wire [31:0] errors;
    wire [29:0] mem_address;
    wire [1:0] mem_id;
    wire mem_read;
    wire mem_write;
    wire [31:0] mem_writedata;
    wire [3:0] mem_writedatamask;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .mem_readdata(mem_readdata),
        .mem_readdataid(mem_readdataid),
        .mem_waitrequest(mem_waitrequest),
        .reset(reset),
        .errors(errors),
        .mem_address(mem_address),
        .mem_id(mem_id),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_writedata(mem_writedata),
        .mem_writedatamask(mem_writedatamask)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            mem_waitrequest = 0;
            mem_readdata = 0;
            mem_readdataid = 0;
            repeat(2) @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Defaults");
            reset_dut();

            #1;


            check_outputs(32'h0, 30'h0, 2'h1, 1'b0, 1'b0, 32'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: ID Mismatch Error Detection");
            reset_dut();


            mem_readdataid = 2'h2;
            mem_readdata = 32'hDEADBEEF;

            repeat(2) @(posedge clock);
            #1;



            if (errors > 0) begin
                $display("PASS: Error detected for ID mismatch");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: No error detected for ID mismatch");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Wait Request Stability");
            reset_dut();

            mem_waitrequest = 1'b1;
            repeat(3) @(posedge clock);
            #1;



            #1;




            check_outputs(errors, 30'h0, 2'h1, 1'b0, 1'b0, 32'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Valid Transaction ID");
            reset_dut();

            mem_readdataid = 2'h1;
            mem_readdata = 32'hCAFEBABE;

            repeat(2) @(posedge clock);
            #1;


            #1;



            check_outputs(32'h0, 30'h0, 2'h1, 1'b0, 1'b0, 32'h0, 4'h0);
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
        input [31:0] expected_errors;
        input [29:0] expected_mem_address;
        input [1:0] expected_mem_id;
        input expected_mem_read;
        input expected_mem_write;
        input [31:0] expected_mem_writedata;
        input [3:0] expected_mem_writedatamask;
        begin
            if (expected_errors === (expected_errors ^ errors ^ expected_errors) &&
                expected_mem_address === (expected_mem_address ^ mem_address ^ expected_mem_address) &&
                expected_mem_id === (expected_mem_id ^ mem_id ^ expected_mem_id) &&
                expected_mem_read === (expected_mem_read ^ mem_read ^ expected_mem_read) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write) &&
                expected_mem_writedata === (expected_mem_writedata ^ mem_writedata ^ expected_mem_writedata) &&
                expected_mem_writedatamask === (expected_mem_writedatamask ^ mem_writedatamask ^ expected_mem_writedatamask)) begin
                $display("PASS");
                $display("  Outputs: errors=%h, mem_address=%h, mem_id=%h, mem_read=%b, mem_write=%b, mem_writedata=%h, mem_writedatamask=%h",
                         errors, mem_address, mem_id, mem_read, mem_write, mem_writedata, mem_writedatamask);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: errors=%h, mem_address=%h, mem_id=%h, mem_read=%b, mem_write=%b, mem_writedata=%h, mem_writedatamask=%h",
                         expected_errors, expected_mem_address, expected_mem_id, expected_mem_read, expected_mem_write, expected_mem_writedata, expected_mem_writedatamask);
                $display("  Got:      errors=%h, mem_address=%h, mem_id=%h, mem_read=%b, mem_write=%b, mem_writedata=%h, mem_writedatamask=%h",
                         errors, mem_address, mem_id, mem_read, mem_write, mem_writedata, mem_writedatamask);
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
        $dumpvars(0,clock, mem_readdata, mem_readdataid, mem_waitrequest, reset, errors, mem_address, mem_id, mem_read, mem_write, mem_writedata, mem_writedatamask);
    end

endmodule
