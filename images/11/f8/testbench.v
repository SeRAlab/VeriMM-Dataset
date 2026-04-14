`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_value;
    reg reset;
    wire [7:0] current_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .node_value(node_value),
        .reset(reset),
        .current_value(current_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            node_value = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Post-Reset Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Node Traversal", test_num);
            reset_dut();
            node_value = 8'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three-Node Linked List Traversal", test_num);
            reset_dut();


            node_value = 8'h11;
            @(posedge clk); #1;


            node_value = 8'h22;
            @(posedge clk); #1;


            node_value = 8'h33;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum and Minimum Value Traversal", test_num);
            reset_dut();

            node_value = 8'hFF;
            @(posedge clk); #1;

            node_value = 8'h00;
            @(posedge clk); #1;

            node_value = 8'hAA;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long Sequence Traversal", test_num);
            reset_dut();

            node_value = 8'h01; @(posedge clk); #1;
            node_value = 8'h02; @(posedge clk); #1;
            node_value = 8'h04; @(posedge clk); #1;
            node_value = 8'h08; @(posedge clk); #1;
            node_value = 8'h10; @(posedge clk); #1;
            node_value = 8'h20; @(posedge clk); #1;
            node_value = 8'h40; @(posedge clk); #1;
            node_value = 8'h80; @(posedge clk); #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            node_value = 8'h55; @(posedge clk); #1;
            node_value = 8'hAA; @(posedge clk); #1;
            node_value = 8'h55; @(posedge clk); #1;
            node_value = 8'hAA; @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
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
        input [7:0] expected_current_value;
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
        $dumpvars(0,clk, node_value, reset, current_value);
    end

endmodule
