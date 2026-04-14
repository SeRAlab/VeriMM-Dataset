`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [7:0] current_data;
    wire end_of_list;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .current_data(current_data),
        .end_of_list(end_of_list)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Traversal", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;



            while (end_of_list === 0) begin
                @(posedge clk);
            end




            #1;





            check_outputs(current_data, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Restarting Traversal", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            while (end_of_list === 0) @(posedge clk);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (end_of_list === 0) @(posedge clk);

            #1;


            check_outputs(current_data, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (2) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single cycle start pulse", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            #1;
            @(posedge clk);
            start = 0;


            while (end_of_list === 0) @(posedge clk);

            #1;


            check_outputs(current_data, 1'b1);
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
        input [7:0] expected_current_data;
        input expected_end_of_list;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data) &&
                expected_end_of_list === (expected_end_of_list ^ end_of_list ^ expected_end_of_list)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h, end_of_list=%b",
                         current_data, end_of_list);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h, end_of_list=%b",
                         expected_current_data, expected_end_of_list);
                $display("  Got:      current_data=%h, end_of_list=%b",
                         current_data, end_of_list);
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
        $dumpvars(0,clk, reset, start, current_data, end_of_list);
    end

endmodule
