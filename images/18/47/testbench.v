`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] index;
    reg reset;
    wire [7:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .index(index),
        .reset(reset),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            index = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Traversal from Index 1", test_num);
            reset_dut();
            index = 4'd1;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Traversal from Index 3 (Multi-step)", test_num);
            reset_dut();
            index = 4'd3;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(8'hB3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Immediate NULL Index", test_num);
            reset_dut();
            index = 4'd0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Node Traversal", test_num);
            reset_dut();
            index = 4'd7;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'hC7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [7:0] expected_value;
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
        $dumpvars(0,clk, index, reset, value);
    end

endmodule
