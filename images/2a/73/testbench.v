`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [127:0] weight_matrix;
    wire [127:0] dist_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .clk(clk),
        .rst(rst),
        .weight_matrix(weight_matrix),
        .dist_matrix(dist_matrix)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            weight_matrix = 0;
            @(posedge clk);
            #2 rst = 0;



            repeat (100) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple Directed Path", test_num);
            rst = 1;




            weight_matrix = {
                8'h00, 8'h05, 8'hFF, 8'hFF,
                8'hFF, 8'h00, 8'h0A, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'h0F,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            };
            @(posedge clk);
            #2 rst = 0;
            repeat (100) @(posedge clk);


            #1;



            check_outputs({
                8'h00, 8'h05, 8'h0F, 8'h1E,
                8'hFF, 8'h00, 8'h0A, 8'h19,
                8'hFF, 8'hFF, 8'h00, 8'h0F,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            });
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shortcut Detection", test_num);
            rst = 1;
            weight_matrix = {
                8'h00, 8'h05, 8'h14, 8'hFF,
                8'hFF, 8'h00, 8'h05, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            };
            @(posedge clk);
            #2 rst = 0;
            repeat (100) @(posedge clk);

            #1;


            check_outputs({
                8'h00, 8'h05, 8'h0A, 8'hFF,
                8'hFF, 8'h00, 8'h05, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            });
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Disconnected Graph", test_num);
            rst = 1;
            weight_matrix = {
                8'h00, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'h00, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            };
            @(posedge clk);
            #2 rst = 0;
            repeat (100) @(posedge clk);

            #1;


            check_outputs({
                8'h00, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'h00, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'h00
            });
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Cyclic Graph", test_num);
            rst = 1;
            weight_matrix = {
                8'h00, 8'h02, 8'hFF, 8'hFF,
                8'hFF, 8'h00, 8'h02, 8'hFF,
                8'hFF, 8'hFF, 8'h00, 8'h02,
                8'h02, 8'hFF, 8'hFF, 8'h00
            };
            @(posedge clk);
            #2 rst = 0;
            repeat (100) @(posedge clk);


            #1;



            check_outputs({
                8'h00, 8'h02, 8'h04, 8'h06,
                8'h06, 8'h00, 8'h02, 8'h04,
                8'h04, 8'h06, 8'h00, 8'h02,
                8'h02, 8'h04, 8'h06, 8'h00
            });
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
        input [127:0] expected_dist_matrix;
        begin
            if (expected_dist_matrix === (expected_dist_matrix ^ dist_matrix ^ expected_dist_matrix)) begin
                $display("PASS");
                $display("  Outputs: dist_matrix=%h",
                         dist_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dist_matrix=%h",
                         expected_dist_matrix);
                $display("  Got:      dist_matrix=%h",
                         dist_matrix);
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
        $dumpvars(0,clk, rst, weight_matrix, dist_matrix);
    end

endmodule
