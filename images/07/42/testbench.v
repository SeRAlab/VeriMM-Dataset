`timescale 1ns/1ps

module conv_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg rst;
    wire [3:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 2'b00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 00 (Initial State)", test_num);
        reset_dut();
        data_in = 2'b00;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 10", test_num);
        reset_dut();
        data_in = 2'b10;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b1110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 01", test_num);
        reset_dut();
        data_in = 2'b01;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 11", test_num);
        reset_dut();
        data_in = 2'b11;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence 10 -> 00", test_num);
        reset_dut();
        data_in = 2'b10;
        @(posedge clk);
        data_in = 2'b00;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence 11 -> 11", test_num);
        reset_dut();
        data_in = 2'b11;
        @(posedge clk);
        data_in = 2'b11;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence 01 -> 10", test_num);
        reset_dut();
        data_in = 2'b01;
        @(posedge clk);
        data_in = 2'b10;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b0101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Flush memory (11 -> 00 -> 00)", test_num);
        reset_dut();
        data_in = 2'b11;
        @(posedge clk);
        data_in = 2'b00;
        @(posedge clk);
        data_in = 2'b00;
        @(posedge clk);
        #2 #1;
 check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_encoder Testbench");
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
        input [3:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, data_in, rst, encoded_out);
    end

endmodule
