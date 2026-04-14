`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    wire [127:0] hmac_output;

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
        .hmac_output(hmac_output)
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            key     = 128'h0;
            message = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Key All Ones, Msg All Zeros", test_num);
            reset_dut();
            key     = 128'hffffffffffffffffffffffffffffffff;
            message = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hffffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Key All Zeros, Msg All Ones", test_num);
            reset_dut();
            key     = 128'h00000000000000000000000000000000;
            message = 128'hffffffffffffffffffffffffffffffff;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hffffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            key     = 128'hffffffffffffffffffffffffffffffff;
            message = 128'hffffffffffffffffffffffffffffffff;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            key     = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            message = 128'h55555555555555555555555555555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hffffffffffffffffffffffffffffffff);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Specific Hex Values", test_num);
            reset_dut();
            key     = 128'h11112222333344445555666677778888;
            message = 128'h88887777666655554444333322221111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h99995555555511111111555555559999);
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
        input [127:0] expected_hmac_output;
        begin
            if (expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output)) begin
                $display("PASS");
                $display("  Outputs: hmac_output=%h",
                         hmac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_output=%h",
                         expected_hmac_output);
                $display("  Got:      hmac_output=%h",
                         hmac_output);
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
        $dumpvars(0,clk, key, message, rst, hmac_output);
    end

endmodule
