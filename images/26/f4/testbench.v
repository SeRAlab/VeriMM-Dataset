`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg reset;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
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
            @(posedge clk);
            reset = 1;
            enable = 0;
            data_in = 32'h0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Zero Input (32'h00000000)");
            reset_dut();
            test_num = test_num + 1;

            data_in = 32'h0000_0000;
            enable = 1;
            @(posedge clk);
            enable = 0;


            repeat (32) @(posedge clk);


            #1;



            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: All-Ones Input (32'hFFFFFFFF)");
            reset_dut();
            test_num = test_num + 1;

            data_in = 32'hFFFF_FFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (32) @(posedge clk);


            #1;



            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Alternating Bits (32'hAAAAAAAA)");
            reset_dut();
            test_num = test_num + 1;

            data_in = 32'hAAAA_AAAA;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (32) @(posedge clk);


            #1;



            check_outputs(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Hex Constant (32'hDEADBEEF)");
            reset_dut();
            test_num = test_num + 1;

            data_in = 32'hDEAD_BEEF;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (32) @(posedge clk);


            #1;



            check_outputs(128'hDEADBEEFDEADBEEFDEADBEEFDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Enable Signal Verification");
            reset_dut();
            test_num = test_num + 1;


            data_in = 32'h1234_5678;
            enable = 0;
            repeat (5) @(posedge clk);



            #1;




            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Avalanche Effect (Single bit change)");
            reset_dut();
            test_num = test_num + 1;


            data_in = 32'hAAAA_AAAB;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (32) @(posedge clk);


            #1;



            check_outputs(128'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB);
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
        input [127:0] expected_hash_out;
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
        $dumpvars(0,clk, data_in, enable, reset, hash_out);
    end

endmodule
