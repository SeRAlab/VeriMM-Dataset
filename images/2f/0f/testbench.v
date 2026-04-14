`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    wire [127:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .hmac(hmac)
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
            message = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros...", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;


            repeat(50) @(posedge clk);


            #1;



            check_outputs(128'h6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Ones...", test_num);
            reset_dut();
            key     = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(128'h95959595959595959595959595959595);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Alternating Bits...", test_num);
            reset_dut();
            key     = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(128'h3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Hex Pattern...", test_num);
            reset_dut();
            key     = 128'hDEADBEEFCAFEBABE0123456789ABCDEF;
            message = 128'h0123456789ABCDEFDEADBEEFCAFEBABE;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(128'h6B492F0D8AEC684A6B492F0D8AEC684A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Simple Key Padding...", test_num);
            reset_dut();
            key     = 128'h000000000000000000000000000000FF;
            message = 128'h112233445566778899AABBCCDDEEFFFF;

            repeat(50) @(posedge clk);

            #1;


            check_outputs(128'h7B48596A3B08192A5B68794A1B28390A);
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
        $dumpvars(0,clk, key, message, rst, hmac);
    end

endmodule
