`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_point;
    reg rst;
    reg start;
    wire [7:0] centroid1;
    wire [7:0] centroid2;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .clk(clk),
        .data_point(data_point),
        .rst(rst),
        .start(start),
        .centroid1(centroid1),
        .centroid2(centroid2),
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
            start = 0;
            data_point = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task send_data;

        input [7:0] val;
        begin
            data_point = val;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Balanced Clusters", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            send_data(8'd10);
            send_data(8'd20);
            send_data(8'd30);
            send_data(8'd40);
            send_data(8'd200);
            send_data(8'd210);
            send_data(8'd220);
            send_data(8'd230);


            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(8'd25, 8'd215, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Sided Distribution (Low)", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            for(i=2; i<=16; i=i+2) begin
                send_data(i[7:0]);
            end

            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(8'd9, 8'd255, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Mid-range Clusters", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            send_data(8'd120); send_data(8'd122); send_data(8'd124); send_data(8'd126);
            send_data(8'd130); send_data(8'd132); send_data(8'd134); send_data(8'd136);

            wait(done == 1);
            @(posedge clk);





            #1;






            check_outputs(8'd123, 8'd133, 1'b1);
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
        input [7:0] expected_centroid1;
        input [7:0] expected_centroid2;
        input expected_done;
        begin
            if (expected_centroid1 === (expected_centroid1 ^ centroid1 ^ expected_centroid1) &&
                expected_centroid2 === (expected_centroid2 ^ centroid2 ^ expected_centroid2) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: centroid1=%h, centroid2=%h, done=%b",
                         centroid1, centroid2, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid1=%h, centroid2=%h, done=%b",
                         expected_centroid1, expected_centroid2, expected_done);
                $display("  Got:      centroid1=%h, centroid2=%h, done=%b",
                         centroid1, centroid2, done);
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
        $dumpvars(0,clk, data_point, rst, start, centroid1, centroid2, done);
    end

endmodule
