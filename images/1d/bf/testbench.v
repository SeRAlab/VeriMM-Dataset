`timescale 1ns/1ps

module simple_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire done;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_sha256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 512-bit Zero Block", test_num);
            reset_dut();

            message = 512'h0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 256'h66687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Padded 'abc' Message", test_num);
            reset_dut();

            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 512-bit All-Ones Block", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 256'hef20907a70823351f2495f4691458022a84358055c17926c4293f7734a78103c);
        end
        endtask

    task testcase004;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Incremental Pattern Block", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[((63-i)*8) +: 8] = i[7:0];
            end

            message = pattern;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 256'h9c258ef9012423793e18a00062489c6d369f698e3b299e52c80302b11566378c);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();

            message = {32{16'h55AA}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 256'h758688467464005d539281a17951233e707e784534f3780332f1430485a3c987);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_sha256 Testbench");
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
        input [255:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, message, rst, start, done, hash);
    end

endmodule
