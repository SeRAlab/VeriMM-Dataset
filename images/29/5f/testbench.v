`timescale 1ns/1ps

module dijkstra_tb;

    // Testbench signals (sequential circuit)
    reg [24:0] adj_matrix;
    reg clk;
    reg rst;
    reg [2:0] source;
    wire done;
    wire [4:0] min_distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
        .source(source),
        .done(done),
        .min_distances(min_distances)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adj_matrix = 0;
            source = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Edges (Source 0)", test_num);
            reset_dut();
            source = 3'd0;
            adj_matrix = 25'h0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear Path 0->1->2", test_num);
            reset_dut();
            source = 3'd0;

            adj_matrix = (1 << 1) | (1 << 7);

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b00111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Linear Path 4->3->2->1->0", test_num);
            reset_dut();
            source = 3'd4;

            adj_matrix = (1 << 23) | (1 << 17) | (1 << 11) | (1 << 5);

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Star Graph from Node 2", test_num);
            reset_dut();
            source = 3'd2;

            adj_matrix = (1 << 10) | (1 << 14);

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b10101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disconnected Graph (Source 1)", test_num);
            reset_dut();
            source = 3'd1;

            adj_matrix = (1 << 8);

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b01010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fully Connected Mesh (Source 0)", test_num);
            reset_dut();
            source = 3'd0;

            adj_matrix = 25'h1FFFFFF;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra Testbench");
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
        input [4:0] expected_min_distances;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_min_distances === (expected_min_distances ^ min_distances ^ expected_min_distances)) begin
                $display("PASS");
                $display("  Outputs: done=%b, min_distances=%h",
                         done, min_distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, min_distances=%h",
                         expected_done, expected_min_distances);
                $display("  Got:      done=%b, min_distances=%h",
                         done, min_distances);
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
        $dumpvars(0,adj_matrix, clk, rst, source, done, min_distances);
    end

endmodule
