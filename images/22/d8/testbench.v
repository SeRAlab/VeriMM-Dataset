`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [3:0] iterations;
    reg rst;
    reg valid;
    wire [3:0] centroid1;
    wire [3:0] centroid2;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .clk(clk),
        .data_in(data_in),
        .iterations(iterations),
        .rst(rst),
        .valid(valid),
        .centroid1(centroid1),
        .centroid2(centroid2),
        .ready(ready)
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
            data_in = 0;
            iterations = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Well-separated clusters", test_num);
            reset_dut();

            iterations = 4'd5;
            valid = 1;


            data_in = 4'd1; @(posedge clk);
            data_in = 4'd2; @(posedge clk);
            data_in = 4'd1; @(posedge clk);
            data_in = 4'd2; @(posedge clk);
            data_in = 4'd10; @(posedge clk);
            data_in = 4'd14; @(posedge clk);
            data_in = 4'd10; @(posedge clk);
            data_in = 4'd14; @(posedge clk);

            valid = 0;
            data_in = 0;


            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(4'd1, 4'd12, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Uniform data points", test_num);
            reset_dut();

            iterations = 4'd2;
            valid = 1;

            repeat(8) begin
                data_in = 4'd5;
                @(posedge clk);
            end

            valid = 0;
            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(4'd5, 4'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple convergence", test_num);
            reset_dut();

            iterations = 4'd2;
            valid = 1;

            data_in = 4'd0; @(posedge clk);
            data_in = 4'd0; @(posedge clk);
            data_in = 4'd0; @(posedge clk);
            data_in = 4'd0; @(posedge clk);
            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);
            data_in = 4'd8; @(posedge clk);

            valid = 0;
            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd8, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max range values", test_num);
            reset_dut();

            iterations = 4'd10;
            valid = 1;

            data_in = 4'd0; @(posedge clk);
            data_in = 4'd1; @(posedge clk);
            data_in = 4'd0; @(posedge clk);
            data_in = 4'd1; @(posedge clk);
            data_in = 4'd15; @(posedge clk);
            data_in = 4'd14; @(posedge clk);
            data_in = 4'd15; @(posedge clk);
            data_in = 4'd14; @(posedge clk);

            valid = 0;
            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(4'd0, 4'd14, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_clustering Testbench");
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
        input [3:0] expected_centroid1;
        input [3:0] expected_centroid2;
        input expected_ready;
        begin
            if (expected_centroid1 === (expected_centroid1 ^ centroid1 ^ expected_centroid1) &&
                expected_centroid2 === (expected_centroid2 ^ centroid2 ^ expected_centroid2) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: centroid1=%h, centroid2=%h, ready=%b",
                         centroid1, centroid2, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid1=%h, centroid2=%h, ready=%b",
                         expected_centroid1, expected_centroid2, expected_ready);
                $display("  Got:      centroid1=%h, centroid2=%h, ready=%b",
                         centroid1, centroid2, ready);
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
        $dumpvars(0,clk, data_in, iterations, rst, valid, centroid1, centroid2, ready);
    end

endmodule
