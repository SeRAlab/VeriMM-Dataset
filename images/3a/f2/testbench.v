`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg reset;
    reg start;
    wire done;
    wire [31:0] output_stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .reset(reset),
        .start(start),
        .done(done),
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
            start = 0;
            key = 0;
            nonce = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h00000000;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(32'h2F1C6B0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            key = 32'h12345678;
            nonce = 32'h00000000;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'h9D4E21BC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h87654321;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'hF0A2B3C4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            key = 32'hAAAAAAAA;
            nonce = 32'h55555555;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(32'h13579BDF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input expected_done;
        input [31:0] expected_output_stream;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_stream === (expected_output_stream ^ output_stream ^ expected_output_stream)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_stream=%h",
                         done, output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_stream=%h",
                         expected_done, expected_output_stream);
                $display("  Got:      done=%b, output_stream=%h",
                         done, output_stream);
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
        $dumpvars(0,clk, key, nonce, reset, start, done, output_stream);
    end

endmodule
