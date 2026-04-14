`timescale 1ns/1ps

module dijkstra_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] source;
    wire [4:0] distances;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra dut (
        .clk(clk),
        .reset(reset),
        .source(source),
        .distances(distances),
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
            source = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Source Node 0", test_num);
            reset_dut();

            source = 5'd0;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(5'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Source Node 1", test_num);
            reset_dut();

            source = 5'd1;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(5'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Source Node 2", test_num);
            reset_dut();

            source = 5'd2;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(5'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: Source Node 31 (Isolated)", test_num);
            reset_dut();

            source = 5'd31;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(5'd31, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra Testbench");
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
        input [4:0] expected_distances;
        input expected_done;
        begin
            if (expected_distances === (expected_distances ^ distances ^ expected_distances) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: distances=%h, done=%b",
                         distances, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distances=%h, done=%b",
                         expected_distances, expected_done);
                $display("  Got:      distances=%h, done=%b",
                         distances, done);
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
        $dumpvars(0,clk, reset, source, distances, done);
    end

endmodule
