`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [63:0] nonce;
    reg reset;
    reg start;
    wire done;
    wire [511:0] output_block;

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
            start = 0;
            key = 0;
            nonce = 0;
            repeat (2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Key and Nonce", test_num);
            reset_dut();


            key = 256'h0;
            nonce = 64'h0;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);




            #1;





            check_outputs(1'b1, 512'h76b8821731590a14ac880698d132fdd6104400912ecb1da21223ab4472888914c62e061b55694c1a9387281a840d238ea5102a54b648e1c66286c9da8f98c84b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Key and Nonce", test_num);
            reset_dut();


            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            nonce = 64'h000000000000004a;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'h10f1e7e1c9446d338f615392723ed95d031950d249f055610b8095f99238804c0df6834571775f0a0586e2467b7e67f08b350f585501869e5f2010892f392942);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Key and Nonce", test_num);
            reset_dut();

            key = {256{1'b1}};
            nonce = {64{1'b1}};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'h196d44548231c54b38d30e5257f897df86884d5f470a793a65074f514b7e8d71235165d2a9385966d90a078b59419d854e7d206f406560965d1b70c677e16335);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Back-to-Back Operation Check", test_num);
            reset_dut();


            key = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            nonce = 64'h5A5A5A5A5A5A5A5A;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);


            key = 256'h0;
            nonce = 64'h1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'h81a8c3d9878201a9387401d2950e334a1945145b02660a927163bc95e4e24a87c6999335f6e806145228693a187e1272013f932e658428131342629f63554e1d);
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
        input [511:0] expected_output_block;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_block === (expected_output_block ^ output_block ^ expected_output_block)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_block=%h",
                         done, output_block);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_block=%h",
                         expected_done, expected_output_block);
                $display("  Got:      done=%b, output_block=%h",
                         done, output_block);
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
        $dumpvars(0,clk, key, nonce, reset, start, done, output_block);
    end

endmodule
