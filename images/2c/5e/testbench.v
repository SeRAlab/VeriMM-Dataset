`timescale 1ns/1ps

module floyd_warshall_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [15:0] weights;
    wire done;
    wire [15:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    floyd_warshall dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .weights(weights),
        .done(done),
        .shortest_paths(shortest_paths)
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
            weights = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task run_floyd_warshall;

        input [15:0] input_matrix [0:N*N-1];
        input [15:0] expected_matrix [0:N*N-1];
        integer i;
        begin
            @(posedge clk);
            start = 1;

            for (i = 0; i < N*N; i = i + 1) begin
                weights = input_matrix[i];
                @(posedge clk);
            end
            start = 0;
            weights = 0;


            wait(done);



            for (i = 0; i < N*N; i = i + 1) begin
                #1;

                check_outputs(1'b1, expected_matrix[i]);
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        reg [15:0] m_in [0:15];
        reg [15:0] m_out [0:15];
        begin
            $display("\nRunning Testcase 001: Basic Path Improvement");
            test_num = test_num + 1;
            reset_dut();


            m_in[0]=0;   m_in[1]=5;   m_in[2]=10;  m_in[3]=INF;
            m_in[4]=INF; m_in[5]=0;   m_in[6]=3;   m_in[7]=INF;
            m_in[8]=INF; m_in[9]=INF; m_in[10]=0;  m_in[11]=1;
            m_in[12]=INF;m_in[13]=INF;m_in[14]=INF;m_in[15]=0;


            m_out[0]=0;   m_out[1]=5;   m_out[2]=8;   m_out[3]=9;
            m_out[4]=INF; m_out[5]=0;   m_out[6]=3;   m_out[7]=4;
            m_out[8]=INF; m_out[9]=INF; m_out[10]=0;  m_out[11]=1;
            m_out[12]=INF;m_out[13]=INF;m_out[14]=INF;m_out[15]=0;

            run_floyd_warshall(m_in, m_out);
        end
        endtask

    task testcase002;

        reg [15:0] m_in [0:15];
        reg [15:0] m_out [0:15];
        begin
            $display("\nRunning Testcase 002: Disconnected Components");
            test_num = test_num + 1;
            reset_dut();

            m_in[0]=0;   m_in[1]=2;   m_in[2]=INF; m_in[3]=INF;
            m_in[4]=2;   m_in[5]=0;   m_in[6]=INF; m_in[7]=INF;
            m_in[8]=INF; m_in[9]=INF; m_in[10]=0;  m_in[11]=4;
            m_in[12]=INF;m_in[13]=INF;m_in[14]=4;  m_in[15]=0;

            m_out[0]=0;  m_out[1]=2;  m_out[2]=INF;m_out[3]=INF;
            m_out[4]=2;  m_out[5]=0;  m_out[6]=INF;m_out[7]=INF;
            m_out[8]=INF;m_out[9]=INF;m_out[10]=0; m_out[11]=4;
            m_out[12]=INF;m_out[13]=INF;m_out[14]=4; m_out[15]=0;

            run_floyd_warshall(m_in, m_out);
        end
        endtask

    task testcase003;

        reg [15:0] m_in [0:15];
        reg [15:0] m_out [0:15];
        begin
            $display("\nRunning Testcase 003: Linear Chain Path Finding");
            test_num = test_num + 1;
            reset_dut();

            m_in[0]=0;   m_in[1]=10;  m_in[2]=INF; m_in[3]=INF;
            m_in[4]=INF; m_in[5]=0;   m_in[6]=10;  m_in[7]=INF;
            m_in[8]=INF; m_in[9]=INF; m_in[10]=0;  m_in[11]=10;
            m_in[12]=INF;m_in[13]=INF;m_in[14]=INF;m_in[15]=0;

            m_out[0]=0;   m_out[1]=10;  m_out[2]=20;  m_out[3]=30;
            m_out[4]=INF; m_out[5]=0;   m_out[6]=10;  m_out[7]=20;
            m_out[8]=INF; m_out[9]=INF; m_out[10]=0;  m_out[11]=10;
            m_out[12]=INF;m_out[13]=INF;m_out[14]=INF;m_out[15]=0;

            run_floyd_warshall(m_in, m_out);
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
        input [15:0] expected_shortest_paths;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: done=%b, shortest_paths=%h",
                         done, shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, shortest_paths=%h",
                         expected_done, expected_shortest_paths);
                $display("  Got:      done=%b, shortest_paths=%h",
                         done, shortest_paths);
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
        $dumpvars(0,clk, rst, start, weights, done, shortest_paths);
    end

endmodule
