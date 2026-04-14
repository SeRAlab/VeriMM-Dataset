`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] head_index;
    reg reset;
    wire [7:0] current_data;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .head_index(head_index),
        .reset(reset),
        .current_data(current_data),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [3:0] start_idx;
        begin
            reset = 1;
            head_index = start_idx;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full Traversal from Head (Index 0)", test_num);
            reset_dut(4'h0);


            repeat (16) begin
                if (!done) @(posedge clk);
            end


            #1;



            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Partial Traversal from Middle (Index 2)", test_num);
            reset_dut(4'h2);

            repeat (16) begin
                if (!done) @(posedge clk);
            end


            #1;



            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Traversal from Tail Node (Index 3)", test_num);
            reset_dut(4'h3);

            repeat (5) begin
                if (!done) @(posedge clk);
            end


            #1;



            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-Traversal", test_num);


            reset_dut(4'h0);
            @(posedge clk);
            @(posedge clk);


            reset_dut(4'h1);

            repeat (16) begin
                if (!done) @(posedge clk);
            end

            #1;


            check_outputs(8'h40, 1'b1);
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
        input expected_done;
        begin
            if (expected_current_data === (expected_current_data ^ current_data ^ expected_current_data) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_data=%h, done=%b",
                         current_data, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_data=%h, done=%b",
                         expected_current_data, expected_done);
                $display("  Got:      current_data=%h, done=%b",
                         current_data, done);
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
        $dumpvars(0,clk, head_index, reset, current_data, done);
    end

endmodule
