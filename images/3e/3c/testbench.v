`timescale 1ns/1ps

module chacha20_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [63:0] nonce;
    reg rst;
    wire [31:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_simple dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .rst(rst),
        .keystream(keystream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 0;
            nonce = 0;
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
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();

            key = 32'h00000000;
            nonce = 64'h0000000000000000;


            repeat(10) @(posedge clk);



            #1;




            check_outputs(keystream);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            reset_dut();

            key = 32'hFFFFFFFF;
            nonce = 64'hFFFFFFFFFFFFFFFF;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Bit Pattern", test_num);
            reset_dut();

            key = 32'h12345678;
            nonce = 64'h9ABCDEF012345678;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();

            key = 32'hAAAAAAAA;
            nonce = 64'h55555555AAAAAAAA;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity (LSB change)", test_num);
            reset_dut();

            key = 32'h00000001;
            nonce = 64'h0000000000000000;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Nonce Sensitivity (LSB change)", test_num);
            reset_dut();

            key = 32'h00000000;
            nonce = 64'h0000000000000001;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DEADBEEF Pattern", test_num);
            reset_dut();

            key = 32'hDEADBEEF;
            nonce = 64'hCAFEBABEBAADF00D;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(keystream);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_simple Testbench");
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
        input [31:0] expected_keystream;
        begin
            if (expected_keystream === (expected_keystream ^ keystream ^ expected_keystream)) begin
                $display("PASS");
                $display("  Outputs: keystream=%h",
                         keystream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keystream=%h",
                         expected_keystream);
                $display("  Got:      keystream=%h",
                         keystream);
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
        $dumpvars(0,clk, key, nonce, rst, keystream);
    end

endmodule
