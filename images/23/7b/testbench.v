`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] block_counter;
    reg clk;
    reg [255:0] key;
    reg [63:0] nonce;
    reg rst;
    wire [511:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .block_counter(block_counter),
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
            rst = 1;
            block_counter = 0;
            key = 0;
            nonce = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            key = 256'h0;
            nonce = 64'h0;
            block_counter = 32'h0;


            repeat(100) @(posedge clk);



            #1;




            check_outputs(512'h76b8821733035a2ee295173b922ee1df3331cbef8b78364428a57f87c14d3e52477c7d95d2de3922e430424a64709f0e4460210008888b3940c6091316c043e2);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            nonce = 64'h000000000000004a;
            block_counter = 32'h00000001;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(512'h374e043547209700e574c89868770c89078652932d561494e1d35a513c79c89421887e07662c4c34d310659616d246c4f923e51f899738f615f33580554f676b);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            key = {8{32'hffffffff}};
            nonce = 64'hffffffffffffffff;
            block_counter = 32'hffffffff;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(512'h28d059080928e08d6c703d90f05500e263d950d3a5323267591600f64c676d631853f9380315e21971775f04230d359685655a6d091e3e788c7f766f5010940a);
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
        input [511:0] expected_keystream;
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
        $dumpvars(0,block_counter, clk, key, nonce, rst, keystream);
    end

endmodule
