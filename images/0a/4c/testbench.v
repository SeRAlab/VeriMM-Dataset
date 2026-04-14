`timescale 1ns/1ps

module AES_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] key;
    reg rst;
    wire [7:0] encrypted_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .encrypted_out(encrypted_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            key = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            reset_dut();
            data_in = 8'h00;
            key = 8'h00;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Ones", test_num);
            reset_dut();
            data_in = 8'hFF;
            key = 8'hFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h63);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data FF, Key 00", test_num);
            reset_dut();
            data_in = 8'hFF;
            key = 8'h00;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Pattern AA/55", test_num);
            reset_dut();
            data_in = 8'hAA;
            key = 8'h55;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Arbitrary Values", test_num);
            reset_dut();
            data_in = 8'h12;
            key = 8'h34;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hF7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_8bit Testbench");
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
        input [7:0] expected_encrypted_out;
        begin
            if (expected_encrypted_out === (expected_encrypted_out ^ encrypted_out ^ expected_encrypted_out)) begin
                $display("PASS");
                $display("  Outputs: encrypted_out=%h",
                         encrypted_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_out=%h",
                         expected_encrypted_out);
                $display("  Got:      encrypted_out=%h",
                         encrypted_out);
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
        $dumpvars(0,clk, data_in, key, rst, encrypted_out);
    end

endmodule
