`timescale 1ns/1ps

module chacha20_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg rst;
    wire [31:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20 dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .rst(rst),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            key = 0;
            nonce = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Inputs, Initial Counter", test_num);
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h00000000;


            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specific Key and Nonce", test_num);
            reset_dut();
            key = 32'h12345678;
            nonce = 32'h87654321;


            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678 ^ 32'h87654321 ^ 32'h0);
        end
        endtask

    task testcase003;

        reg [31:0] local_key;
        reg [31:0] local_nonce;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Counter Increment (Multiple Cycles)", test_num);
            reset_dut();
            local_key = 32'hAAAA_BBBB;
            local_nonce = 32'h5555_4444;
            key = local_key;
            nonce = local_nonce;



            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(local_key ^ local_nonce ^ 32'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-stream Input Change", test_num);
            reset_dut();
            key = 32'h0;
            nonce = 32'h0;

            @(posedge clk);
            @(posedge clk);

            key = 32'hFFFF_FFFF;
            nonce = 32'h0000_0000;

            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFF_FFFF ^ 32'h0000_0000 ^ 32'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Re-initialization", test_num);
            reset_dut();
            key = 32'h0;
            nonce = 32'h0;

            repeat(10) @(posedge clk);

            reset_dut();
            key = 32'h0;
            nonce = 32'h0;

            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20 Testbench");
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
        input [31:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, key, nonce, rst, output_data);
    end

endmodule
