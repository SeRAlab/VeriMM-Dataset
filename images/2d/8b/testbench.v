`timescale 1ns/1ps

module simple_hash_table_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg op;
    reg rst;
    reg [15:0] value;
    wire [15:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_hash_table dut (
        .clk(clk),
        .key(key),
        .op(op),
        .rst(rst),
        .value(value),
        .out_value(out_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        op = 0;
        key = 0;
        value = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Basic Insert and Retrieve");


        key = 8'h0A;
        value = 16'hABCD;
        op = 0;
        @(posedge clk);


        #1;
        op = 1;
        key = 8'h0A;
        @(posedge clk);

        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Overwrite Existing Key");


        key = 8'h05;
        value = 16'h1111;
        op = 0;
        @(posedge clk);


        #1;
        value = 16'h2222;
        @(posedge clk);


        #1;
        op = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Multiple Keys");


        key = 8'h01;
        value = 16'hAAAA;
        op = 0;
        @(posedge clk);


        #1;
        key = 8'h02;
        value = 16'hBBBB;
        @(posedge clk);


        #1;
        op = 1;
        key = 8'h01;
        @(posedge clk);

        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Reset Clearing");


        key = 8'hFF;
        value = 16'hFFFF;
        op = 0;
        @(posedge clk);


        reset_dut();


        op = 1;
        key = 8'hFF;
        @(posedge clk);

        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Hash Collision Overwrite");


        key = 8'h01;
        value = 16'h5555;
        op = 0;
        @(posedge clk);


        #1;
        key = 8'h11;
        value = 16'h6666;
        @(posedge clk);


        #1;
        op = 1;
        key = 8'h01;
        @(posedge clk);

        #1;


        #1;



        check_outputs(16'h6666);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_hash_table Testbench");
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
        input [15:0] expected_out_value;
        begin
            if (expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_value=%h",
                         out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_value=%h",
                         expected_out_value);
                $display("  Got:      out_value=%h",
                         out_value);
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
        $dumpvars(0,clk, key, op, rst, value, out_value);
    end

endmodule
