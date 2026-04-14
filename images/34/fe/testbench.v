`timescale 1ns/1ps

module chacha20_stream_cipher_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg reset;
    wire [31:0] output_stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_stream_cipher dut (
        .clk(clk),
        .key(key),
        .reset(reset),
        .output_stream(output_stream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero Key Initial State", test_num);
            reset_dut();
            key = 32'h00000000;



            if (output_stream !== 32'h0) begin
                $display("PASS: Seed is non-zero: %h", output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Seed is zero or no output");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        reg [31:0] val1, val2;
        begin
            test_num = 2;
            $display("Testcase %0d: Key XOR Logic Verification", test_num);


            reset_dut();
            key = 32'h00000000;
            val1 = output_stream;


            reset_dut();
            key = 32'hFFFFFFFF;
            val2 = output_stream;


            #1;



            check_outputs(val1 ^ 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        reg [31:0] first_val;
        begin
            test_num = 3;
            $display("Testcase %0d: LFSR Progression Check", test_num);
            reset_dut();
            key = 32'h12345678;
            first_val = output_stream;

            repeat(5) @(posedge clk);
            #1;

            if (output_stream != first_val) begin
                $display("PASS: Output changed over 5 cycles (%h -> %h)", first_val, output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output stuck at %h", first_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [31:0] first_run;
        begin
            test_num = 4;
            $display("Testcase %0d: Consistency Check", test_num);

            reset_dut();
            key = 32'hA5A5A5A5;
            repeat(10) @(posedge clk);
            #1;
            first_run = output_stream;

            reset_dut();
            key = 32'hA5A5A5A5;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(first_run);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High-bit Key Influence", test_num);
            reset_dut();
            key = 32'h80000000;
            repeat(2) @(posedge clk);
            #1;


            if (output_stream !== 32'h0) begin
                $display("PASS: Output generated with MSB set in key");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output is zero");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_stream_cipher Testbench");
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
        input [31:0] expected_output_stream;
        begin
            if (expected_output_stream === (expected_output_stream ^ output_stream ^ expected_output_stream)) begin
                $display("PASS");
                $display("  Outputs: output_stream=%h",
                         output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_stream=%h",
                         expected_output_stream);
                $display("  Got:      output_stream=%h",
                         output_stream);
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
        $dumpvars(0,clk, key, reset, output_stream);
    end

endmodule
