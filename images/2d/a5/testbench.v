`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    wire [127:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .hash(hash),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            message = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: 64 bytes of 0x00", test_num);
            reset_dut();
            message = 512'h0;



            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(128'h3b5d3c7d207e37dceea3d01dbcfcc0c9, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: 64 bytes of 0xFF", test_num);
            reset_dut();
            message = {64{8'hFF}};

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(128'hf1741753752e505a76e1919324021312, 1'b1);
        end
        endtask

    task testcase003;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Incremental Byte Sequence", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end
            message = pattern;

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(128'h9558a8a4f61f7051df52701419730f78, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: 64 bytes of ASCII 'a' (0x61)", test_num);
            reset_dut();
            message = {64{8'h61}};

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(128'h06656759200388e235e121544c414603, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Specific Hex Pattern", test_num);
            reset_dut();
            message = 512'hDEADBEEFCAFEBABE123456788765432100112233445566778899AABBCCDDEEFF_DEADBEEFCAFEBABE123456788765432100112233445566778899AABBCCDDEEFF;

            wait(ready === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(128'h3660500742589574d754326f59c77170, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
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
        $dumpvars(0,clk, message, reset, hash, ready);
    end

endmodule
