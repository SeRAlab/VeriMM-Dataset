`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] message;
    reg reset;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            message = 0;
            @(posedge clk);
            #2 reset = 0;

            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();
            message = 128'h0;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(128'h2f05477fc24bb4faefd864f7246c1d38);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            reset_dut();
            message = {128{1'b1}};
            repeat (100) @(posedge clk);

            #1;


            check_outputs(128'ha924f1146747d89069d255140b2f1503);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Byte Pattern", test_num);
            reset_dut();
            message = 128'h000102030405060708090A0B0C0D0E0F;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(128'h3661413a1a9e992176466f2081d668f4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Pattern (0x5A)", test_num);
            reset_dut();
            message = {16{8'h5A}};
            repeat (100) @(posedge clk);
            #1;

            check_outputs(128'h6961559e79393e87858c894236a287c8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Recovery After Mid-Process Reset", test_num);
            reset_dut();
            message = 128'hFFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000;
            repeat (20) @(posedge clk);
            reset_dut();
            message = 128'h123456789ABCDEF0123456789ABCDEF0;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(128'hb312788d750c41b6980e1c8d76899538);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash;
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
        $dumpvars(0,clk, message, reset, hash);
    end

endmodule
