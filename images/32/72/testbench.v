`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [255:0] weights;
    wire [255:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .clk(clk),
        .reset(reset),
        .weights(weights),
        .shortest_paths(shortest_paths)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            weights = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Simple Chain Graph");
            reset_dut();


            weights = {
                16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF,
                16'h0002, 16'h0000, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0003, 16'h0000, 16'hFFFF,
                16'hFFFF, 16'hFFFF, 16'h0005, 16'h0000
            };


            repeat (100) @(posedge clk);


            #1;



            check_outputs({
                16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF,
                16'h0002, 16'h0000, 16'hFFFF, 16'hFFFF,
                16'h0005, 16'h0003, 16'h0000, 16'hFFFF,
                16'h000A, 16'h0008, 16'h0005, 16'h0000
            });
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Indirect Shortcut");
            reset_dut();
            weights = {
                16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0000, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0005, 16'h0000, 16'hFFFF,
                16'h0014, 16'hFFFF, 16'h0005, 16'h0000
            };

            repeat (100) @(posedge clk);


            #1;



            check_outputs({
                16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0000, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0005, 16'h0000, 16'hFFFF,
                16'h000A, 16'h0005, 16'h0005, 16'h0000
            });
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Disconnected Graph");
            reset_dut();
            weights = {
                16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'h0000, 16'hFFFF, 16'hFFFF,
                16'hFFFF, 16'hFFFF, 16'h0000, 16'hFFFF,
                16'hFFFF, 16'hFFFF, 16'hFFFF, 16'h0000
            };

            repeat (100) @(posedge clk);

            #1;


            check_outputs(weights);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Fully Connected Symmetric");
            reset_dut();
            weights = {
                16'h0000, 16'h0001, 16'h0001, 16'h0001,
                16'h0001, 16'h0000, 16'h0001, 16'h0001,
                16'h0001, 16'h0001, 16'h0000, 16'h0001,
                16'h0001, 16'h0001, 16'h0001, 16'h0000
            };

            repeat (100) @(posedge clk);

            #1;


            check_outputs(weights);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("floyd_warshall Testbench");
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
        input [255:0] expected_shortest_paths;
        begin
            if (expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: shortest_paths=%h",
                         shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_paths=%h",
                         expected_shortest_paths);
                $display("  Got:      shortest_paths=%h",
                         shortest_paths);
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
        $dumpvars(0,clk, reset, weights, shortest_paths);
    end

endmodule
