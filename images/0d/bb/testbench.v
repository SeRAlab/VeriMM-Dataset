`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg reset;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All Zeros", test_num);
            reset_dut();
            data_in = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            repeat (100) @(posedge clk);
            #1;

            check_outputs(256'hed065a5d120967d32734154765c9c933158c3ca76607917622cc596701a00742);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All Ones", test_num);
            reset_dut();
            data_in = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(256'heef1c15c26b801a21648a12702787e90c9ef3012975878413b5bf5553e1a8d05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Hex Pattern", test_num);
            reset_dut();
            data_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(256'hd7990159f8ed1c440a37452d3a391584e03d3663b652611634b07137b01d361c);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: ASCII sequence", test_num);
            reset_dut();

            data_in = 256'h6162636465666768696a6b6c6d6e6f707172737475767778797a414243444546;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(256'h3319047910168925567a5b3a3721345d311910609f7a5531d054593f66c0d8df);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
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
        input [255:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, reset, hash_out);
    end

endmodule
