`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] centroid_0;
    wire [7:0] centroid_1;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .centroid_0(centroid_0),
        .centroid_1(centroid_1),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task load_data_8;

        input [7:0] d0, d1, d2, d3, d4, d5, d6, d7;
        begin
            @(posedge clk); data_in = d0;
            @(posedge clk); data_in = d1;
            @(posedge clk); data_in = d2;
            @(posedge clk); data_in = d3;
            @(posedge clk); data_in = d4;
            @(posedge clk); data_in = d5;
            @(posedge clk); data_in = d6;
            @(posedge clk); data_in = d7;
            @(posedge clk); data_in = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Well-separated clusters", test_num);
            reset_dut();


            load_data_8(8'd10, 8'd11, 8'd12, 8'd13, 8'd100, 8'd101, 8'd102, 8'd103);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            #10;

            #1;


            check_outputs(8'h0B, 8'h65, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %02d: Higher value clusters", test_num);
            reset_dut();

            load_data_8(8'd40, 8'd42, 8'd44, 8'd46, 8'd200, 8'd202, 8'd204, 8'd206);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #10;

            #1;


            check_outputs(8'h2B, 8'hCB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Closely packed clusters", test_num);
            reset_dut();

            load_data_8(8'd1, 8'd2, 8'd1, 8'd2, 8'd5, 8'd6, 8'd5, 8'd6);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #10;


            #1;



            check_outputs(8'h01, 8'h05, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All points identical", test_num);
            reset_dut();

            load_data_8(8'd50, 8'd50, 8'd50, 8'd50, 8'd50, 8'd50, 8'd50, 8'd50);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            #10;

            #1;


            check_outputs(8'h32, 8'h32, 1'b1);
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
        input [7:0] expected_centroid_0;
        input [7:0] expected_centroid_1;
        input expected_done;
        begin
            if (expected_centroid_0 === (expected_centroid_0 ^ centroid_0 ^ expected_centroid_0) &&
                expected_centroid_1 === (expected_centroid_1 ^ centroid_1 ^ expected_centroid_1) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: centroid_0=%h, centroid_1=%h, done=%b",
                         centroid_0, centroid_1, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_0=%h, centroid_1=%h, done=%b",
                         expected_centroid_0, expected_centroid_1, expected_done);
                $display("  Got:      centroid_0=%h, centroid_1=%h, done=%b",
                         centroid_0, centroid_1, done);
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
        $dumpvars(0,clk, data_in, reset, start, centroid_0, centroid_1, done);
    end

endmodule
