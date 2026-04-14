`timescale 1ns/1ps

module bfs_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_value;
    reg rst;
    reg valid;
    wire [7:0] bfs_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_traversal dut (
        .clk(clk),
        .node_value(node_value),
        .rst(rst),
        .valid(valid),
        .bfs_output(bfs_output),
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
            valid = 0;
            node_value = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Node Tree", test_num);
            reset_dut();

            @(posedge clk);
            node_value = 8'h0A;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(8'h0A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 3-Node Binary Tree", test_num);
            reset_dut();


            @(posedge clk);
            node_value = 8'h01; valid = 1;
            @(posedge clk);
            node_value = 8'h02; valid = 1;
            @(posedge clk);
            node_value = 8'h03; valid = 1;
            @(posedge clk);
            valid = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(8'h03, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] vals [0:6];
        begin
            vals[0] = 8'h11; vals[1] = 8'h22; vals[2] = 8'h33;
            vals[3] = 8'h44; vals[4] = 8'h55; vals[5] = 8'h66; vals[6] = 8'h77;

            test_num = test_num + 1;
            $display("\nTest Case %0d: 7-Node Full Binary Tree", test_num);
            reset_dut();


            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
                node_value = vals[i];
                valid = 1;
            end
            @(posedge clk);
            valid = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(8'h77, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tree with Specific Byte Values", test_num);
            reset_dut();

            @(posedge clk);
            node_value = 8'hFF; valid = 1;
            @(posedge clk);
            node_value = 8'hAA; valid = 1;
            @(posedge clk);
            node_value = 8'h55; valid = 1;
            @(posedge clk);
            node_value = 8'h00; valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done);
            @(posedge clk);

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
        $display("bfs_traversal Testbench");
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
        input [7:0] expected_bfs_output;
        input expected_done;
        begin
            if (expected_bfs_output === (expected_bfs_output ^ bfs_output ^ expected_bfs_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: bfs_output=%h, done=%b",
                         bfs_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bfs_output=%h, done=%b",
                         expected_bfs_output, expected_done);
                $display("  Got:      bfs_output=%h, done=%b",
                         bfs_output, done);
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
        $dumpvars(0,clk, node_value, rst, valid, bfs_output, done);
    end

endmodule
