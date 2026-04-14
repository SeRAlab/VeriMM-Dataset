`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_symbol;
    reg reset;
    wire [6:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .input_symbol(input_symbol),
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
            input_symbol = 4'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            input_symbol = 4'b0000;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: LSB Set", test_num);
            reset_dut();
            input_symbol = 4'b0001;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(7'b1010001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();
            input_symbol = 4'b1111;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Pattern 1010", test_num);
            reset_dut();
            input_symbol = 4'b1010;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0011010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: MSB Set", test_num);
            reset_dut();
            input_symbol = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0111000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input [6:0] expected_encoded_output;
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
        $dumpvars(0,clk, input_symbol, reset, encoded_output);
    end

endmodule
