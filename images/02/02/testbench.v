`timescale 1ns/1ps

module pipeline_incrementer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in_value;
    reg reset;
    wire [4:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_incrementer dut (
        .clk(clk),
        .in_value(in_value),
        .reset(reset),
        .out_value(out_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_value = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Input 0", test_num);
            in_value = 5'd0;

            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Input 10", test_num);
            in_value = 5'd10;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Input 27 (Wrap to 0)", test_num);
            in_value = 5'd27;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Input 31 (Wrap to 4)", test_num);
            in_value = 5'd31;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Input 26", test_num);
            in_value = 5'd26;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_incrementer Testbench");
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
        input [4:0] expected_out_value;
        begin
            if (expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_value=%h",
                         out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_value=%h",
                         expected_out_value);
                $display("  Got:      out_value=%h",
                         out_value);
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
        $dumpvars(0,clk, in_value, reset, out_value);
    end

endmodule
