`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] msg;
    reg reset;
    wire [127:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .msg(msg),
        .reset(reset),
        .hmac(hmac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 0;
            msg = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Message", test_num);
            reset_dut();
            key = 128'h0;
            msg = 128'h0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Message", test_num);
            reset_dut();
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            msg = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(128'h95959595959595959595959595959595);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Message equals XOR Constant", test_num);
            reset_dut();
            key = 128'h123456789ABCDEF0123456789ABCDEF0;
            msg = 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern (0xAA)", test_num);
            reset_dut();
            key = 128'h0;
            msg = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(128'hc0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Specific Hex Pattern", test_num);
            reset_dut();
            key = 128'hFEDCBA9876543210FEDCBA9876543210;
            msg = 128'h0123456789ABCDEF0123456789ABCDEF;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(128'h6b492f0de3c1a7856b492f0de3c1a785);
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
        input [127:0] expected_hmac;
        begin
            if (expected_hmac === (expected_hmac ^ hmac ^ expected_hmac)) begin
                $display("PASS");
                $display("  Outputs: hmac=%h",
                         hmac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac=%h",
                         expected_hmac);
                $display("  Got:      hmac=%h",
                         hmac);
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
        $dumpvars(0,clk, key, msg, reset, hmac);
    end

endmodule
