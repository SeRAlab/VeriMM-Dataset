`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg rst;
    reg valid;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input All Zeros", test_num);
            reset_dut();
            data_in = 256'h0;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(80) @(posedge clk);

            #1;


            check_outputs(256'hed020f1e1a032bb5e010c7daadc2842c4486300f423d6226785e8d9db9895474);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input All Ones", test_num);
            reset_dut();
            data_in = {256{1'b1}};
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'hef4379a02476579b128527a297926715f60570b5514f76bc09f188365922c152);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Alternating 0101 (0x55...)", test_num);
            reset_dut();
            data_in = {128{2'b01}};
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'h61d33116d8a3424d80a184ef4f48b067a9a13b569503a45c38753228ec561845);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Alternating 1010 (0xAA...)", test_num);
            reset_dut();
            data_in = {128{2'b10}};
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'h67a544866f8115629c19ec41725b7a13c988647e335555139a067096e248b61e);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Sequential Bytes (00 to 1F)", test_num);
            reset_dut();
            data_in = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'h8d8f763327d8199998188040d7c22501097240c5f590554552b07d6396e95350);
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
        $dumpvars(0,clk, data_in, rst, valid, hash_out);
    end

endmodule
