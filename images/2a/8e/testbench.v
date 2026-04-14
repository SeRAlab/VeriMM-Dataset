`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] start_addr;
    wire done;
    wire [31:0] node_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .reset(reset),
        .start_addr(start_addr),
        .done(done),
        .node_value(node_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_addr = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Null Pointer Start", test_num);
            reset_dut();
            start_addr = 32'h0000_0000;


            fork : wait_or_timeout_001
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout_001;
                end
                begin
                    repeat(10) @(posedge clk);
                    disable wait_or_timeout_001;
                end
            join


            #1;



            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Single Node Traversal", test_num);
            reset_dut();

            start_addr = 32'h0000_0010;

            fork : wait_or_timeout_002
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout_002;
                end
                begin
                    repeat(50) @(posedge clk);
                    disable wait_or_timeout_002;
                end
            join


            #1;



            check_outputs(1'b1, 32'h0000_AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Multi-Node Traversal", test_num);
            reset_dut();

            start_addr = 32'h0000_0020;

            fork : wait_or_timeout_003
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout_003;
                end
                begin
                    repeat(200) @(posedge clk);
                    disable wait_or_timeout_003;
                end
            join


            #1;



            check_outputs(1'b1, 32'h0000_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Boundary Address Traversal", test_num);
            reset_dut();
            start_addr = 32'hFFFF_FFFC;

            fork : wait_or_timeout_004
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout_004;
                end
                begin
                    repeat(50) @(posedge clk);
                    disable wait_or_timeout_004;
                end
            join

            #1;


            check_outputs(1'b1, 32'hFFFF_FFFF);
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
        input expected_done;
        input [31:0] expected_node_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_node_value === (expected_node_value ^ node_value ^ expected_node_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, node_value=%h",
                         done, node_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, node_value=%h",
                         expected_done, expected_node_value);
                $display("  Got:      done=%b, node_value=%h",
                         done, node_value);
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
        $dumpvars(0,clk, reset, start_addr, done, node_value);
    end

endmodule
