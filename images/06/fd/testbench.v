`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg reset;
    wire [31:0] output_block;

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
        .output_block(output_block)
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
            nonce = 32'h0;
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
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h00000000;

            repeat(20) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h819349a1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            reset_dut();
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            repeat(20) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h4b6a12f9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();
            key = 32'h55555555;
            nonce = 32'hAAAAAAAA;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2d8e4c10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Standard Key/Nonce Pattern", test_num);
            reset_dut();
            key = 32'h12345678;
            nonce = 32'h9ABCDEF0;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h90abcdef);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking One in Key", test_num);
            reset_dut();
            key = 32'h00000001;
            nonce = 32'h00000000;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h7c12b3a4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking One in Nonce", test_num);
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h80000000;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h15a2e3f4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Reset Recovery", test_num);


            reset_dut();
            key = 32'hA5A5A5A5;
            nonce = 32'h5A5A5A5A;
            repeat(20) @(posedge clk);


            reset_dut();
            key = 32'hA5A5A5A5;
            nonce = 32'h5A5A5A5A;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hb7d8c9e0);
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
        input [31:0] expected_output_block;
        begin
            if (expected_output_block === (expected_output_block ^ output_block ^ expected_output_block)) begin
                $display("PASS");
                $display("  Outputs: output_block=%h",
                         output_block);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_block=%h",
                         expected_output_block);
                $display("  Got:      output_block=%h",
                         output_block);
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
        $dumpvars(0,clk, key, nonce, reset, output_block);
    end

endmodule
