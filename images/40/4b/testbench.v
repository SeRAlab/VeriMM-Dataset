`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [159:0] edges;
    reg rst;
    reg [3:0] source;
    wire [79:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .clk(clk),
        .edges(edges),
        .rst(rst),
        .source(source),
        .distances(distances)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            edges = 160'h0;
            source = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            source = 4'h0;



            edges = { {112{1'b1}}, 16'h2302, 16'h120a, 16'h0105 };

            #1;


            check_outputs(80'hFFFFFFFFFFFF110F0500);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            source = 4'h0;

            edges = { {112{1'b1}}, 16'h2102, 16'h0201, 16'h010a };

            #1;


            check_outputs(80'hFFFFFFFFFFFFFF030100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            source = 4'h5;
            edges = { {144{1'b1}}, 16'h0105 };

            #1;


            check_outputs(80'hFFFFFFFF00FFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            source = 4'h0;
            edges = { 16'h8901, 16'h7801, 16'h6701, 16'h5601, 16'h4501,
                      16'h3401, 16'h2301, 16'h1201, 16'h0101, 16'hFFFF };

            #1;


            check_outputs(80'h09080706050403020100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bellman_ford Testbench");
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
        input [79:0] expected_distances;
        begin
            if (expected_distances === (expected_distances ^ distances ^ expected_distances)) begin
                $display("PASS");
                $display("  Outputs: distances=%h",
                         distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distances=%h",
                         expected_distances);
                $display("  Got:      distances=%h",
                         distances);
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
        $dumpvars(0,clk, edges, rst, source, distances);
    end

endmodule
