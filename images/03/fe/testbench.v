`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] message;
    reg reset;
    wire [7:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .enable(enable),
        .message(message),
        .reset(reset),
        .encoded_output(encoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            message = 4'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Message", test_num);
            reset_dut();
            message = 4'b0000;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit (1000)", test_num);
            reset_dut();
            message = 4'b1000;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;


            #1;



            check_outputs(8'b1000_1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (1010)", test_num);
            reset_dut();
            message = 4'b1010;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;

            #1;


            check_outputs(8'b1010_0110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Message", test_num);
            reset_dut();
            message = 4'b1111;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;

            #1;


            check_outputs(8'b1111_1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low Nibble bit (0001)", test_num);
            reset_dut();
            message = 4'b0001;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;

            #1;


            check_outputs(8'b0001_1101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ReedSolomonEncoder Testbench");
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
        input [7:0] expected_encoded_output;
        begin
            if (expected_encoded_output === (expected_encoded_output ^ encoded_output ^ expected_encoded_output)) begin
                $display("PASS");
                $display("  Outputs: encoded_output=%h",
                         encoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_output=%h",
                         expected_encoded_output);
                $display("  Got:      encoded_output=%h",
                         encoded_output);
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
        $dumpvars(0,clk, enable, message, reset, encoded_output);
    end

endmodule
