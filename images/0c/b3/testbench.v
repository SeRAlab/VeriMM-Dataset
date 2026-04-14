`timescale 1ns/1ps

module sha256_preprocessing_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_preprocessing dut (
        .clk(clk),
        .message(message),
        .rst(rst),
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
            message = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512-bit Block of Zeros", test_num);
            reset_dut();
            message = 512'h0;

            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'hda5698d87bf87474084514580fa800288f18222c709534010e9914b38d03c1d6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Padded 'abc' Block", test_num);
            reset_dut();
            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Padded Empty String Block", test_num);
            reset_dut();
            message = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512-bit Block of All Ones", test_num);
            reset_dut();
            message = {16{32'hFFFFFFFF}};
            repeat(80) @(posedge clk);
            #1;

            check_outputs(256'h7790b17165842823617300f89a9f23439e7ca856950e39556276707a095c1a79);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_preprocessing Testbench");
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
        input [255:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, message, rst, hash);
    end

endmodule
