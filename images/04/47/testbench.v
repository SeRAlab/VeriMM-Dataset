`timescale 1ns/1ps

module hmac_generator_tb;

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
    hmac_generator dut (
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            key = 128'h0;
            message = 128'h0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All Zeros", test_num);
            #1;

            check_outputs(128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'h0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All-Ones Key, Zero Message", test_num);
            #1;

            check_outputs(128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            key = 128'h0;
            message = 128'h11111111111111111111111111111111;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Simple Message Pattern", test_num);
            #1;

            check_outputs(128'h7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Alternating Bits", test_num);
            #1;

            check_outputs(128'h3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            key = 128'h123456789ABCDEF0123456789ABCDEF0;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All Ones Message", test_num);
            #1;

            check_outputs(128'h95959595959595959595959595959595);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            key = 128'h0;
            message = 128'hDEADBEEFDEADBEEFDEADBEEFDEADBEEF;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Random Hex Pattern", test_num);
            #1;

            check_outputs(128'hB4C7D485B4C7D485B4C7D485B4C7D485);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
