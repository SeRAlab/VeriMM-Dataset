`timescale 1ns/1ps

module binary_decoder_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] binary_in;
    reg clk;
    reg rst;
    wire [3:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder dut (
        .binary_in(binary_in),
        .clk(clk),
        .rst(rst),
        .one_hot_out(one_hot_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            binary_in = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %0d: binary_in = 00", test_num);
            reset_dut();
            binary_in = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %0d: binary_in = 01", test_num);
            reset_dut();
            binary_in = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %0d: binary_in = 10", test_num);
            reset_dut();
            binary_in = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %0d: binary_in = 11", test_num);
            reset_dut();
            binary_in = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %0d: Reset Behavior", test_num);

            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1111);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder Testbench");
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
        input [3:0] expected_one_hot_out;
        begin
            if (expected_one_hot_out === (expected_one_hot_out ^ one_hot_out ^ expected_one_hot_out)) begin
                $display("PASS");
                $display("  Outputs: one_hot_out=%h",
                         one_hot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot_out=%h",
                         expected_one_hot_out);
                $display("  Got:      one_hot_out=%h",
                         one_hot_out);
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
        $dumpvars(0,binary_in, clk, rst, one_hot_out);
    end

endmodule
