`timescale 1ns/1ps

module md5_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    wire [31:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_simple dut (
        .clk(clk),
        .data(data),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data <= 64'h0;
            repeat (2) @(posedge clk);
        end
        endtask
    task wait_for_result;

        begin
            repeat (64) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input All Zeros", test_num);
            reset_dut();
            data <= 64'h0000000000000000;
            wait_for_result();

            #1;


            check_outputs(32'hD41D8CD9);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input All Ones", test_num);
            reset_dut();
            data <= 64'hFFFFFFFFFFFFFFFF;
            wait_for_result();

            #1;


            check_outputs(32'h28C1D615);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Input Alternating Pattern AAAA", test_num);
            reset_dut();
            data <= 64'hAAAAAAAAAAAAAAAA;
            wait_for_result();

            #1;


            check_outputs(32'hA0B1C2D3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Input Hex Sequence", test_num);
            reset_dut();
            data <= 64'h0123456789ABCDEF;
            wait_for_result();

            #1;


            check_outputs(32'h5D41402A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Single Bit High (MSB)", test_num);
            reset_dut();
            data <= 64'h8000000000000000;
            wait_for_result();

            #1;


            check_outputs(32'h1B6D1B6D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_simple Testbench");
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
        input [31:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, data, hash);
    end

endmodule
