`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr_a;
    reg [4:0] addr_b;
    reg ce_a;
    reg ce_b;
    reg clk_a;
    reg clk_b;
    reg [31:0] di_b;
    reg we_b;
    wire [31:0] do_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .ce_a(ce_a),
        .ce_b(ce_b),
        .clk_a(clk_a),
        .clk_b(clk_b),
        .di_b(di_b),
        .we_b(we_b),
        .do_a(do_a)
    );

    // Clock generation (10ns period)
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

        task reset_dut;

        begin
            addr_a = 0;
            addr_b = 0;
            ce_a = 0;
            ce_b = 0;
            we_b = 0;
            di_b = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Read (Expect 0)");
            reset_dut();
            @(negedge clk_a);
            addr_a = 5'd15;
            ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Write/Read");
            reset_dut();

            @(negedge clk_b);
            addr_b = 5'd10;
            di_b = 32'hDEADBEEF;
            we_b = 1'b1;
            ce_b = 1'b1;
            @(posedge clk_b);
            @(negedge clk_b);
            we_b = 1'b0;
            ce_b = 1'b0;


            @(negedge clk_a);
            addr_a = 5'd10;
            ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Sequential Write/Read");
            reset_dut();

            @(negedge clk_b);
            addr_b = 5'd20; di_b = 32'h12345678; we_b = 1'b1; ce_b = 1'b1;
            @(posedge clk_b);

            @(negedge clk_b);
            addr_b = 5'd21; di_b = 32'h87654321; we_b = 1'b1; ce_b = 1'b1;
            @(posedge clk_b);
            @(negedge clk_b);
            we_b = 0; ce_b = 0;


            @(negedge clk_a);
            addr_a = 5'd21; ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write Enable Check");
            reset_dut();
            @(negedge clk_b);
            addr_b = 5'd5;
            di_b = 32'hFFFFFFFF;
            we_b = 1'b0;
            ce_b = 1'b1;
            @(posedge clk_b);

            @(negedge clk_a);
            addr_a = 5'd5;
            ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Chip Enable B Check");
            reset_dut();
            @(negedge clk_b);
            addr_b = 5'd7;
            di_b = 32'hAAAA5555;
            we_b = 1'b1;
            ce_b = 1'b0;
            @(posedge clk_b);

            @(negedge clk_a);
            addr_a = 5'd7;
            ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Simultaneous Access");
            reset_dut();

            @(negedge clk_a);
            addr_b = 5'd1; di_b = 32'h11112222; we_b = 1'b1; ce_b = 1'b1;
            addr_a = 5'd0; ce_a = 1'b1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h00000000);


            @(negedge clk_a);
            addr_a = 5'd1;
            @(posedge clk_a);
            #1;
            #1;

            check_outputs(32'h11112222);
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
        input [31:0] expected_do_a;
        begin
            if (expected_do_a === (expected_do_a ^ do_a ^ expected_do_a)) begin
                $display("PASS");
                $display("  Outputs: do_a=%h",
                         do_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do_a=%h",
                         expected_do_a);
                $display("  Got:      do_a=%h",
                         do_a);
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
        $dumpvars(0,addr_a, addr_b, ce_a, ce_b, clk_a, clk_b, di_b, we_b, do_a);
    end

endmodule
