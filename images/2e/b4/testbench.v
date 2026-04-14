`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_data;
    reg reset;
    wire [3:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        in_data = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input = 0, Expected Output = 7", test_num);
        reset_dut();
        @(posedge clk);
        in_data = 4'd0;

        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input = 5, Expected Output = 12", test_num);
        reset_dut();
        @(posedge clk);
        in_data = 4'd5;
        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(4'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input = 9 (Overflow Case), Expected Output = 0", test_num);
        reset_dut();
        @(posedge clk);
        in_data = 4'd9;
        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input = 15 (Max Input), Expected Output = 6", test_num);
        reset_dut();
        @(posedge clk);
        in_data = 4'd15;
        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input = 2, Expected Output = 9", test_num);
        reset_dut();
        @(posedge clk);
        in_data = 4'd2;
        repeat(7) @(posedge clk);
        #1 #1;
 check_outputs(4'd9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
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
        input [3:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, reset, out_data);
    end

endmodule
