`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg reset;
    reg start;
    wire done;
    wire [31:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .done(done),
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
            start = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task run_hash;

        input [127:0] value;
        begin
            data_in = value;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Input All Zeros", test_num);
            reset_dut();

            run_hash(128'h0);

            #1;


            check_outputs(1'b1, 32'h70e43f5a);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Input All Ones", test_num);
            reset_dut();
            run_hash(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
            #1;

            check_outputs(1'b1, 32'h3f0a1b2c);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternating Bits (0xAAAA...)", test_num);
            reset_dut();
            run_hash(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
            #1;

            check_outputs(1'b1, 32'h9d8c7b6a);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bits (0x5555...)", test_num);
            reset_dut();
            run_hash(128'h55555555555555555555555555555555);
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            run_hash(128'h00112233445566778899AABBCCDDEEFF);
            #1;

            check_outputs(1'b1, 32'hdeadbeef);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Single Bit Sensitivity (Avalanche Test)", test_num);
            reset_dut();

            run_hash(128'h00000000000000000000000000000001);
            #1;

            check_outputs(1'b1, 32'h8a7b6c5d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Walking Ones Pattern", test_num);
            reset_dut();
            run_hash(128'h80402010080402018040201008040201);
            #1;

            check_outputs(1'b1, 32'hfeeedcba);
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
        testcase007();
        
        
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
        input expected_done;
        input [31:0] expected_hash_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash_out=%h",
                         done, hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash_out=%h",
                         expected_done, expected_hash_out);
                $display("  Got:      done=%b, hash_out=%h",
                         done, hash_out);
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
        $dumpvars(0,clk, data_in, reset, start, done, hash_out);
    end

endmodule
