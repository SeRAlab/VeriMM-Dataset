`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] head;
    reg rst;
    reg start_traversal;
    wire [4:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .head(head),
        .rst(rst),
        .start_traversal(start_traversal),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            head = 0;
            start_traversal = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Starting at head 0, traversing for 2 steps...", test_num);
            reset_dut();

            head = 5'h00;
            start_traversal = 1;
            @(posedge clk);
            #1 start_traversal = 0;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Starting at head 5, traversing for 3 steps...", test_num);
            reset_dut();

            head = 5'h05;
            start_traversal = 1;
            @(posedge clk);
            #1 start_traversal = 0;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Checking initial value after start_traversal at head 0xA...", test_num);
            reset_dut();

            head = 5'h0A;
            start_traversal = 1;
            @(posedge clk);
            #1 start_traversal = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Resetting mid-traversal...", test_num);
            reset_dut();

            head = 5'h10;
            start_traversal = 1;
            @(posedge clk);
            #1 start_traversal = 0;
            repeat (2) @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_current_value;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h",
                         current_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h",
                         expected_current_value);
                $display("  Got:      current_value=%h",
                         current_value);
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
        $dumpvars(0,clk, head, rst, start_traversal, current_value);
    end

endmodule
