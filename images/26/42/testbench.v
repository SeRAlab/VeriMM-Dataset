`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg insert_en;
    reg [7:0] insert_value;
    reg rst;
    wire [7:0] current_value;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .en(en),
        .insert_en(insert_en),
        .insert_value(insert_value),
        .rst(rst),
        .current_value(current_value),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            insert_en = 0;
            insert_value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Insertion and Traversal", test_num);
            reset_dut();


            insert_en = 1;
            insert_value = 8'hAA;
            @(posedge clk);
            #1;
            insert_en = 0;


            en = 1;
            @(posedge clk);
            #1;
            en = 0;


            #1;



            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Insertions and Full Traversal", test_num);
            reset_dut();


            insert_en = 1; insert_value = 8'h11; @(posedge clk); #1;

            insert_en = 1; insert_value = 8'h22; @(posedge clk); #1;

            insert_en = 1; insert_value = 8'h33; @(posedge clk); #1;
            insert_en = 0;


            en = 1; @(posedge clk); #1;

            @(posedge clk); #1;

            @(posedge clk); #1;
            en = 0;


            #1;



            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Traversal (Done Signal Check)", test_num);
            reset_dut();


            insert_en = 1; insert_value = 8'hA1; @(posedge clk); #1;
            insert_en = 1; insert_value = 8'hB2; @(posedge clk); #1;
            insert_en = 1; insert_value = 8'hC3; @(posedge clk); #1;
            insert_en = 0;


            en = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            en = 0;


            #1;



            check_outputs(8'hB2, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty List Traversal", test_num);
            reset_dut();


            en = 1;
            @(posedge clk);
            #1;
            en = 0;


            #1;



            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_current_value;
        input expected_done;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, done=%b",
                         current_value, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, done=%b",
                         expected_current_value, expected_done);
                $display("  Got:      current_value=%h, done=%b",
                         current_value, done);
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
        $dumpvars(0,clk, en, insert_en, insert_value, rst, current_value, done);
    end

endmodule
