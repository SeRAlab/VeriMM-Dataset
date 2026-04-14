`timescale 1ns/1ps

module FloydWarshall_tb;

    // Testbench signals (sequential circuit)
    reg [127:0] adjacency_matrix;
    reg clk;
    reg rst;
    wire [127:0] shortest_path_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FloydWarshall dut (
        .adjacency_matrix(adjacency_matrix),
        .clk(clk),
        .rst(rst),
        .shortest_path_matrix(shortest_path_matrix)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adjacency_matrix = 0;
            @(posedge clk);
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple path optimization", test_num);
            reset_dut();

            adjacency_matrix = 128'h00FFFFFF_0200FFFF_FF0100FF_FF0A0300;


            repeat(100) @(posedge clk);





            #1;






            check_outputs(128'h00FFFFFF_0200FFFF_030100FF_06040300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disconnected Graph", test_num);
            reset_dut();
            adjacency_matrix = 128'h00FFFFFF_FFFF00FF_FFFFFF00_FFFFFF00;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(128'h00FFFFFF_FFFF00FF_FFFFFF00_FFFFFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linear Chain", test_num);
            reset_dut();

            adjacency_matrix = 128'h00FFFFFF_0200FFFF_FF0200FF_FFFF0200;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(128'h00FFFFFF_0200FFFF_040200FF_06040200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Shortcuts", test_num);
            reset_dut();







            adjacency_matrix = 128'h00FFFFFF_020002FF_0A00FF00_FF050A00;

            repeat(100) @(posedge clk);





            #1;






            check_outputs(128'h00FFFFFF_020002FF_0A00FF00_07050700);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FloydWarshall Testbench");
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
        input [127:0] expected_shortest_path_matrix;
        begin
            if (expected_shortest_path_matrix === (expected_shortest_path_matrix ^ shortest_path_matrix ^ expected_shortest_path_matrix)) begin
                $display("PASS");
                $display("  Outputs: shortest_path_matrix=%h",
                         shortest_path_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_path_matrix=%h",
                         expected_shortest_path_matrix);
                $display("  Got:      shortest_path_matrix=%h",
                         shortest_path_matrix);
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
        $dumpvars(0,adjacency_matrix, clk, rst, shortest_path_matrix);
    end

endmodule
