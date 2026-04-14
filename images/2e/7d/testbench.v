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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Directed Path", test_num);
            reset_dut();

            weights = pack_matrix(
                16'h0,   16'h5,   INF,     INF,
                INF,     16'h0,   16'h5,   INF,
                INF,     INF,     16'h0,   16'h5,
                INF,     INF,     INF,     16'h0
            );


            repeat(50) @(posedge clk);

            #1;


            check_outputs(pack_matrix(
                16'h0,   16'h5,   16'hA,   16'hF,
                INF,     16'h0,   16'h5,   16'hA,
                INF,     INF,     16'h0,   16'h5,
                INF,     INF,     INF,     16'h0
            ));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shortcut Optimization", test_num);
            reset_dut();

            weights = pack_matrix(
                16'h0,   16'h2,   16'h32,  INF,
                16'h2,   16'h0,   16'h2,   INF,
                16'h32,  16'h2,   16'h0,   INF,
                INF,     INF,     INF,     16'h0
            );

            repeat(50) @(posedge clk);

            #1;


            check_outputs(pack_matrix(
                16'h0,   16'h2,   16'h4,   INF,
                16'h2,   16'h0,   16'h2,   INF,
                16'h4,   16'h2,   16'h0,   INF,
                INF,     INF,     INF,     16'h0
            ));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disconnected Components", test_num);
            reset_dut();

            weights = pack_matrix(
                16'h0,   16'hA,   INF,     INF,
                16'hA,   16'h0,   INF,     INF,
                INF,     INF,     16'h0,   16'h1,
                INF,     INF,     16'h1,   16'h0
            );

            repeat(50) @(posedge clk);

            #1;


            check_outputs(pack_matrix(
                16'h0,   16'hA,   INF,     INF,
                16'hA,   16'h0,   INF,     INF,
                INF,     INF,     16'h0,   16'h1,
                INF,     INF,     16'h1,   16'h0
            ));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Fully Connected Unit Graph", test_num);
            reset_dut();

            weights = pack_matrix(
                16'h0,   16'h1,   16'h1,   16'h1,
                16'h1,   16'h0,   16'h1,   16'h1,
                16'h1,   16'h1,   16'h0,   16'h1,
                16'h1,   16'h1,   16'h1,   16'h0
            );

            repeat(50) @(posedge clk);

            #1;


            check_outputs(pack_matrix(
                16'h0,   16'h1,   16'h1,   16'h1,
                16'h1,   16'h0,   16'h1,   16'h1,
                16'h1,   16'h1,   16'h0,   16'h1,
                16'h1,   16'h1,   16'h1,   16'h0
            ));
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
