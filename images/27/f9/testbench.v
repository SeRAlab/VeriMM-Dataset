`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg reset;
    reg start;
    wire done;
    wire [255:0] hash_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_sha256 dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .start(start),
        .done(done),
        .hash_output(hash_output)
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
            message = 0;
            repeat(5) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All Zeros (Key and Message)", test_num);
            reset_dut();


            key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            message = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hedaa69512351239c43831b0e352f75d1656c9a2d3e1d670417730e84b8401398);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All Ones (Key and Message)", test_num);
            reset_dut();


            key = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'he62c8e31005a83764835697d8123c533e46c92d547f6071a690e8c898c0b9688);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Incremental Patterns", test_num);
            reset_dut();


            key = 256'h0101010101010101010101010101010101010101010101010101010101010101;
            message = 256'h0202020202020202020202020202020202020202020202020202020202020202;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h06c1968874a1599374092b772c91341c594c44933a033320f269a918a0058e51);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: ASCII Character Pattern", test_num);
            reset_dut();


            key = 256'h6b65796b65796b65796b65796b65796b65796b65796b65796b65796b65796b65;

            message = 256'h6d73676d73676d73676d73676d73676d73676d73676d73676d73676d73676d73;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hc53f86e579738f615e4538805f410777098e9c60e0a5996053351d3b5b637f76);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_sha256 Testbench");
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
        input [255:0] expected_hash_output;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash_output=%h",
                         done, hash_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash_output=%h",
                         expected_done, expected_hash_output);
                $display("  Got:      done=%b, hash_output=%h",
                         done, hash_output);
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
        $dumpvars(0,clk, key, message, reset, start, done, hash_output);
    end

endmodule
