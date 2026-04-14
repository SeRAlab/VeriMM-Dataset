`timescale 1ns/1ps

module hmac_example_tb;

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
    hmac_example dut (
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
        key = 128'h0;
        message = 128'h0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic XOR calculation", test_num);
        reset_dut();
        key     = 128'h0123456789ABCDEF0123456789ABCDEF;
        message = 128'hFEDCBA9876543210FEDCBA9876543210;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros input", test_num);
        reset_dut();
        key     = 128'h0;
        message = 128'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones input", test_num);
        reset_dut();
        key     = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        reset_dut();
        key     = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        message = 128'h55555555555555555555555555555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Key identical to message", test_num);
        reset_dut();
        key     = 128'hA1B2C3D4E5F6A7B8C9D0E1F2A3B4C5D6;
        message = 128'hA1B2C3D4E5F6A7B8C9D0E1F2A3B4C5D6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify Reset overrides input", test_num);
        reset_dut();

        key     = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        message = 128'h0;

        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
        rst = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary data check", test_num);
        reset_dut();
        key     = 128'hCAFEBABEDEADF00DCAFEBABEDEADF00D;
        message = 128'h13371337133713371337133713371337;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hCAFEBABEDEADF00DCAFEBABEDEADF00D ^ 128'h13371337133713371337133713371337);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_example Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
