`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] next_node;
    reg [31:0] node_value;
    reg reset;
    wire done;
    wire [31:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .next_node(next_node),
        .node_value(node_value),
        .reset(reset),
        .done(done),
        .out_value(out_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            next_node = 0;
            node_value = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single node list (Tail is head)", test_num);
            reset_dut();


            node_value = 32'hAAAA_BBBB;
            next_node = 32'h0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Two node traversal", test_num);
            reset_dut();


            node_value = 32'd100;
            next_node = 32'h0000_0001;
            @(posedge clk);
            #1;


            node_value = 32'd200;
            next_node = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 32'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Three node traversal", test_num);
            reset_dut();


            node_value = 32'h1; next_node = 32'hA; @(posedge clk); #1;

            node_value = 32'h2; next_node = 32'hB; @(posedge clk); #1;

            node_value = 32'h3; next_node = 32'h0; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 32'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Traversal with node values equal to zero", test_num);
            reset_dut();

            node_value = 32'hFFFF_FFFF; next_node = 32'h1; @(posedge clk); #1;
            node_value = 32'h0000_0000; next_node = 32'h2; @(posedge clk); #1;
            node_value = 32'h1234_5678; next_node = 32'h0; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Five node list traversal", test_num);
            reset_dut();

            node_value = 32'd10; next_node = 32'h1; @(posedge clk); #1;
            node_value = 32'd20; next_node = 32'h2; @(posedge clk); #1;
            node_value = 32'd30; next_node = 32'h3; @(posedge clk); #1;
            node_value = 32'd40; next_node = 32'h4; @(posedge clk); #1;
            node_value = 32'd50; next_node = 32'h0; @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 32'd50);
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
        input expected_done;
        input [31:0] expected_out_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out_value=%h",
                         done, out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out_value=%h",
                         expected_done, expected_out_value);
                $display("  Got:      done=%b, out_value=%h",
                         done, out_value);
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
        $dumpvars(0,clk, next_node, node_value, reset, done, out_value);
    end

endmodule
