`timescale 1ns/1ps

module sha256_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg rst;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_hash dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 256'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            $display("Testcase %0d: 256-bit Zero Input", test_num);
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'h66687aadf86273f9d863cda37567b36f33f0b69a197b00018c0d957396062464);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            $display("Testcase %0d: Incremental Pattern Input", test_num);
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'h1007788470a133467c6999719369a473468593a54b3837941566378e907d398f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            $display("Testcase %0d: All Ones Input", test_num);
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'h3168a6493f65679905c1062972986f3f019688df7550f7574347781031d27572);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 256'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
            $display("Testcase %0d: 0xA5 Repeated Pattern", test_num);
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'h0098f98f6d239c9f69749f76a084c015b637d97e411c97a2ccb262a690e11894);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            data_in = 256'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
            @(posedge clk);
            #2;


            $display("Testcase %0d: Verify Reset Clears Output", test_num);
            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;
            #1;

            check_outputs(256'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_hash Testbench");
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
        input [255:0] expected_hash_out;
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
        $dumpvars(0,clk, data_in, rst, hash_out);
    end

endmodule
