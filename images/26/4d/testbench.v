`timescale 1ns/1ps

module sha256_single_block_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message_block;
    reg rst;
    wire [255:0] hash_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_single_block dut (
        .clk(clk),
        .message_block(message_block),
        .rst(rst),
        .hash_output(hash_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message_block = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All-Zeros Block", test_num);
            reset_dut();
            message_block = 512'h0;


            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'hda5698d852e911833f526845bdc98b5ef3e019749b1e7f07347d519398450c25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All-Ones Block", test_num);
            reset_dut();
            message_block = {16{32'hFFFFFFFF}};

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'hef2c0a96f3044439c369e8b62551e18d7b3260c679a6d0937a09280f55b1191a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 'abc' Padded Block", test_num);
            reset_dut();
            message_block = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating 0xA5 Pattern", test_num);
            reset_dut();
            message_block = {64{8'hA5}};

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h474f85e5052478546199b508f75567b578c2e6462740a66d03f0b096f6e804f3);
        end
        endtask

    task testcase005;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incrementing Byte Pattern", test_num);
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end
            message_block = pattern;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h030f81d58204b4c78736d70c406085a86f990a424a66a7b78997a3a93e3d6e5d);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_single_block Testbench");
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
        input [255:0] expected_hash_output;
        begin
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h",
                         hash_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h",
                         expected_hash_output);
                $display("  Got:      hash_output=%h",
                         hash_output);
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
        $dumpvars(0,clk, message_block, rst, hash_output);
    end

endmodule
