`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] list_data;
    reg [4:0] next_ptr;
    reg reset;
    wire current_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .list_data(list_data),
        .next_ptr(next_ptr),
        .reset(reset),
        .current_data(current_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            list_data = 5'b0;
            next_ptr = 5'b0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: List 10101 - Expecting last node (index 4) to be 1", test_num);
            reset_dut();
            list_data = 5'b10101;
            next_ptr  = 5'b11110;


            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: List 01111 - Expecting last node (index 4) to be 0", test_num);
            reset_dut();
            list_data = 5'b01111;
            next_ptr  = 5'b11110;

            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: List 11111 - Expecting last node to be 1", test_num);
            reset_dut();
            list_data = 5'b11111;
            next_ptr  = 5'b11110;

            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: List 00000 - Expecting last node to be 0", test_num);
            reset_dut();
            list_data = 5'b00000;
            next_ptr  = 5'b11110;

            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: List 10101 - Double check alternating pattern", test_num);
            reset_dut();
            list_data = 5'b10101;
            next_ptr  = 5'b11110;

            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_current_data;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data)) begin
                $display("PASS");
                $display("  Outputs: current_data=%b",
                         current_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%b",
                         expected_current_data);
                $display("  Got:      current_data=%b",
                         current_data);
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
        $dumpvars(0,clk, list_data, next_ptr, reset, current_data);
    end

endmodule
