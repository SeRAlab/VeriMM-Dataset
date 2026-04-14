`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] index;
    wire [15:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .clk(clk),
        .index(index),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            index = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Accessing Index 0 (Head)", test_num);
            index = 3'd0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'hA000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Accessing Index 1", test_num);
            index = 3'd1;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'hB001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Accessing Index 3", test_num);
            index = 3'd3;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(16'hD003);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Accessing Maximum Index 7", test_num);
            index = 3'd7;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(16'hF007);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Rapid Switch (Index 2)", test_num);
            index = 3'd2;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'hC002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
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
        input [15:0] expected_value;
        begin
            if (expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: value=%h",
                         value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h",
                         expected_value);
                $display("  Got:      value=%h",
                         value);
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
        $dumpvars(0,clk, index, value);
    end

endmodule
