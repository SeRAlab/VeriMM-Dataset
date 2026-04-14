`timescale 1ns/1ps

module nonce_incrementer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] nonce_in;
    reg rst;
    wire [31:0] nonce_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nonce_incrementer dut (
        .clk(clk),
        .nonce_in(nonce_in),
        .rst(rst),
        .nonce_out(nonce_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [31:0] initial_nonce;
        begin
            rst = 1;
            nonce_in = initial_nonce;
            @(posedge clk);
            #1 rst = 0;



        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment from 0x0", test_num);
            reset_dut(32'h0000_0000);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover Check from 0xFFFFFFFF", test_num);
            reset_dut(32'hFFFF_FFFF);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Increments (5 steps)", test_num);
            reset_dut(32'h1234_5678);
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(32'h1234_567D);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Increment 0x0000FFFF", test_num);
            reset_dut(32'h0000_FFFF);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0001_0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Step (256 increments)", test_num);
            reset_dut(32'hAAAA_0000);
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk);
            end
            #1 #1;
 check_outputs(32'hAAAA_0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input Isolation Check", test_num);
            reset_dut(32'h0000_000A);
            @(posedge clk);
            nonce_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0000_000C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nonce_incrementer Testbench");
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
        input [31:0] expected_nonce_out;
        begin
            if (expected_nonce_out === (expected_nonce_out ^ nonce_out ^ expected_nonce_out)) begin
                $display("PASS");
                $display("  Outputs: nonce_out=%h",
                         nonce_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nonce_out=%h",
                         expected_nonce_out);
                $display("  Got:      nonce_out=%h",
                         nonce_out);
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
        $dumpvars(0,clk, nonce_in, rst, nonce_out);
    end

endmodule
