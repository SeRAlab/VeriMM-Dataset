`timescale 1ns/1ps

module chacha20_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg rst;
    wire [31:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_pipeline dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .rst(rst),
        .keystream(keystream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("--- Resetting System ---");
            rst = 1;
            key = 32'h0;
            nonce = 32'h0;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Latency Check", test_num);
            reset_dut();

            key = 32'hA5A5A5A5;
            nonce = 32'h00000001;


            repeat(4) @(posedge clk);
            #1;



            #1;




            check_outputs(32'hA5A5A5A5 ^ 32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Stream Increment Check", test_num);
            reset_dut();

            key = 32'h12345678;
            nonce = 32'h00000010;


            repeat(4) @(posedge clk);


            #1 #1;
 check_outputs(32'h12345678 ^ 32'h00000010);


            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678 ^ 32'h00000011);


            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678 ^ 32'h00000012);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Propagation Check", test_num);
            reset_dut();


            key = 32'hFFFF0000;
            nonce = 32'h1000;
            @(posedge clk);


            key = 32'h0000FFFF;
            nonce = 32'h2000;
            @(posedge clk);


            repeat(3) @(posedge clk);
            #1 $display("Checking first input set result...");
            #1;

            check_outputs(32'hFFFF0000 ^ 32'h1000);


            @(posedge clk);
            #1 $display("Checking second input set result...");
            #1;

            check_outputs(32'h0000FFFF ^ 32'h2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior Check", test_num);
            reset_dut();

            key = 32'hBADC0DE1;
            nonce = 32'h5555;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(32'hBADC0DE1 ^ 32'h5555);


            $display("Asserting reset...");
            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            key = 32'hBADC0DE1;
            nonce = 32'h9999;


            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(32'hBADC0DE1 ^ 32'h9999);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_pipeline Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [31:0] expected_keystream;
        begin
            if (expected_keystream === (expected_keystream ^ keystream ^ expected_keystream)) begin
                $display("PASS");
                $display("  Outputs: keystream=%h",
                         keystream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keystream=%h",
                         expected_keystream);
                $display("  Got:      keystream=%h",
                         keystream);
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
        $dumpvars(0,clk, key, nonce, rst, keystream);
    end

endmodule
