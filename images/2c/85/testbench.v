`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] message;
    reg reset;
    wire [7:0] mac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .mac(mac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        key = 8'h00;
        message = 8'h00;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        key = 8'h00;
        message = 8'h00;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0x00, Msg=0x00", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        key = 8'h00;
        message = 8'hFF;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0x00, Msg=0xFF", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        key = 8'hAA;
        message = 8'h00;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0xAA, Msg=0x00", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        key = 8'hFF;
        message = 8'hFF;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0xFF, Msg=0xFF", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        key = 8'h55;
        message = 8'hAA;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0x55, Msg=0xAA", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        key = 8'h12;
        message = 8'h34;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0x12, Msg=0x34", test_num);
        #1;

        check_outputs(8'h26);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        key = 8'hDE;
        message = 8'hAD;
        @(posedge clk);
        #1;
        $display("Test %0d: Key=0xDE, Msg=0xAD", test_num);
        #1;

        check_outputs(8'h73);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        key = 8'h0F;
        message = 8'hF0;
        @(posedge clk);
        key = 8'hC3;
        message = 8'h3C;
        @(posedge clk);
        #1;
        $display("Test %0d: Dynamic Input Test (0xC3 ^ 0x3C)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_mac;
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
        $dumpvars(0,clk, key, message, reset, mac);
    end

endmodule
