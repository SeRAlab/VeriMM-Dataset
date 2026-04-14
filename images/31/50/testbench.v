`timescale 1ns/1ps

module pipeline_2stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_2stage dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        @(posedge clk);
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Input 0", test_num);
        reset_dut();
        data_in = 8'd0;
        @(posedge clk);
        data_in = 8'hFF;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(16'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Input 10", test_num);
        reset_dut();
        data_in = 8'd10;
        @(posedge clk);
        data_in = 8'h00;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(16'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Input 255", test_num);
        reset_dut();
        data_in = 8'd255;
        @(posedge clk);
        data_in = 8'h00;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(16'd520);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Input 1", test_num);
        reset_dut();
        data_in = 8'd1;
        @(posedge clk);
        data_in = 8'h00;
        @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(16'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_2stage Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
