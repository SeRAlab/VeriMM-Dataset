`timescale 1ns/1ps

module sha256_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg reset;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_processor dut (
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
            $display("\nResetting DUT...");
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (512-bit block of 0x00)", test_num);
            reset_dut();
            data_in = 512'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'hda5698be17b9b46962335799779fbeca8ce5d491c0d26243bafef94183c8574b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (512-bit block of 0xFF)", test_num);
            reset_dut();
            data_in = {16{32'hFFFFFFFF}};
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'h664c399a5e8276f5713df0d099953934f2d72111d4f23b3a6289b33e9d8c7c99);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Standard 'abc' Padded Block", test_num);
            reset_dut();
            data_in = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (0xAA...)", test_num);
            reset_dut();
            data_in = {64{8'hAA}};
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'hc14170668a69a4891b0f59f6358c2803c72b847424b94e8037380299b106296b);
        end
        endtask

    task testcase005;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            for(i=0; i<64; i=i+1) pattern[i*8 +: 8] = i;
            data_in = pattern;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'hf710471c62f2701b2f9f8e43477e62744ec491752b0561e14918e6e89791440d);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_processor Testbench");
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
