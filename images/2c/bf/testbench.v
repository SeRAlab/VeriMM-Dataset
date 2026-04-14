`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    wire [127:0] mac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .mac(mac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        key = 128'b0;
        message = 128'b0;
        #20;
        @(posedge clk);
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        reset_dut();
        key = 128'h00000000000000000000000000000000;
        message = 128'h00000000000000000000000000000000;


        repeat(50) @(posedge clk);


        #1;



        check_outputs(128'h74e65166092104576311db9f614f0e54);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones", test_num);
        reset_dut();
        key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(128'ha316f3945939281734526189ac32e122);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bits", test_num);
        reset_dut();
        key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        message = 128'h55555555555555555555555555555555;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(128'h82193234567890abcdef1234567890ab);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Specific Hex Pattern", test_num);
        reset_dut();
        key = 128'h0102030405060708090a0b0c0d0e0f10;
        message = 128'hdeadbeefdeadbeefdeadbeefdeadbeef;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(128'h45ab321cdef9876543210fedcba98765);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Bit Message", test_num);
        reset_dut();
        key = 128'h4b657920446174612048657265212121;
        message = 128'h00000000000000000000000000000001;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(128'h9f8e7d6c5b4a39281706f5e4d3c2b1a0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input [127:0] expected_mac;
        begin
            if (expected_mac === (expected_mac ^ mac ^ expected_mac)) begin
                $display("PASS");
                $display("  Outputs: mac=%h",
                         mac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac=%h",
                         expected_mac);
                $display("  Got:      mac=%h",
                         mac);
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
        $dumpvars(0,clk, key, message, rst, mac);
    end

endmodule
