`timescale 1ns/1ps

module k_means_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [44:0] data_points;
    reg reset;
    wire [44:0] centroids;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    k_means dut (
        .clk(clk),
        .data_points(data_points),
        .reset(reset),
        .centroids(centroids),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_points = 45'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identical Points", test_num);
            reset_dut();

            data_points = {5{9'h049}};


            wait(valid == 1'b1);
            @(posedge clk);


            #1;



            check_outputs({5{9'h049}}, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Two Distinct Clusters", test_num);
            reset_dut();



            data_points = {9'h1FF, 9'h1B6, 9'h000, 9'h000, 9'h049};

            wait(valid == 1'b1);
            @(posedge clk);





            #1;






            check_outputs({9'h1B6, 9'h1B6, 9'h000, 9'h000, 9'h000}, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Axial Separation", test_num);
            reset_dut();


            data_points = {9'h007, 9'h006, 9'h040, 9'h008, 9'h000};

            wait(valid == 1'b1);
            @(posedge clk);



            #1;




            check_outputs({9'h006, 9'h006, 0'h000, 9'h000, 9'h000}, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Spread", test_num);
            reset_dut();



            data_points = {9'h1FF, 9'h1FF, 9'h000, 9'h000, 9'h000};

            wait(valid == 1'b1);
            @(posedge clk);

            #1;


            check_outputs({9'h1FF, 9'h1FF, 9'h000, 9'h000, 9'h000}, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("k_means Testbench");
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
        input [44:0] expected_centroids;
        input expected_valid;
        begin
            if (expected_centroids === (expected_centroids ^ centroids ^ expected_centroids) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: centroids=%h, valid=%b",
                         centroids, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroids=%h, valid=%b",
                         expected_centroids, expected_valid);
                $display("  Got:      centroids=%h, valid=%b",
                         centroids, valid);
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
        $dumpvars(0,clk, data_points, reset, centroids, valid);
    end

endmodule
