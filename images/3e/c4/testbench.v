`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg insert;
    reg [7:0] new_data;
    reg reset;
    wire done;
    wire [7:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .enable(enable),
        .insert(insert),
        .new_data(new_data),
        .reset(reset),
        .done(done),
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
            enable = 0;
            insert = 0;
            new_data = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task insert_node;

        input [7:0] data;
        begin
            @(posedge clk);
            new_data = data;
            insert = 1;
            @(posedge clk);
            insert = 0;
            new_data = 0;
            repeat(1) @(posedge clk);
        end
        endtask

    task run_traversal;

        begin
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;

            fork : wait_done
                begin
                    wait(done == 1);
                end
                begin
                    repeat(100) @(posedge clk);
                end
            join_any
            disable wait_done;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Insert 1 Node and Traverse", test_num);
            reset_dut();
            insert_node(8'hA5);
            run_traversal();

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Insert 3 Nodes and Traverse", test_num);
            reset_dut();
            insert_node(8'h11);
            insert_node(22);
            insert_node(8'h33);
            run_traversal();

            #1;


            check_outputs(1'b1, 8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Traverse Empty List", test_num);
            reset_dut();
            run_traversal();

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Insert 8 Nodes and Traverse", test_num);
            reset_dut();
            for(i = 1; i <= 8; i = i + 1) begin
                insert_node(i[7:0]);
            end
            run_traversal();

            #1;


            check_outputs(1'b1, 8'h08);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple traversals on same list", test_num);
            reset_dut();
            insert_node(8'hDE);
            insert_node(8'hAD);
            run_traversal();
            repeat(5) @(posedge clk);
            run_traversal();
            #1;

            check_outputs(1'b1, 8'hAD);
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
        testcase006();
        
        
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
        input expected_done;
        input [7:0] expected_out_data;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out_data=%h",
                         done, out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out_data=%h",
                         expected_done, expected_out_data);
                $display("  Got:      done=%b, out_data=%h",
                         done, out_data);
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
        $dumpvars(0,clk, enable, insert, new_data, reset, done, out_data);
    end

endmodule
