`timescale 1ns/1ps

module sha256_stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    wire [31:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_stage dut (
        .clk(clk),
        .data_in(data_in),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            data_in = 512'b0;

            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Block", test_num);
            reset_dut();
            data_in = 512'h0;


            repeat (100) @(posedge clk);

            #1;


            check_outputs(32'hda5698be);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Padded 'abc' Block", test_num);
            reset_dut();
            data_in = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(32'hba7816bf);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Block", test_num);
            reset_dut();
            data_in = {16{32'hffffffff}};

            repeat (100) @(posedge clk);

            #1;


            check_outputs(32'h78cc0765);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                data_in[((63-i)*8) +: 8] = i[7:0];
            end

            repeat (100) @(posedge clk);

            #1;


            check_outputs(32'h7404e4c2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating A5 Pattern", test_num);
            reset_dut();
            data_in = {16{32'ha5a5a5a5}};

            repeat (100) @(posedge clk);

            #1;


            check_outputs(32'he85a557b);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_stage Testbench");
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
        input [31:0] expected_hash_out;
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
        $dumpvars(0,clk, data_in, hash_out);
    end

endmodule
