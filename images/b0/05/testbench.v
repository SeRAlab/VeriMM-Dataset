`timescale 1ns/1ps

module rising_edge_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rising_edge_counter dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            in = 0;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single rising edge detection", test_num);
            reset_dut();

            @(negedge clk);
            in = 0;
            @(negedge clk);
            in = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple rising edges (5 edges)", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                @(negedge clk);
                in = 0;
                @(negedge clk);
                in = 1;
                repeat(2) @(posedge clk);
            end

            #1;


            check_outputs(8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained high input", test_num);
            reset_dut();

            @(negedge clk);
            in = 1;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained low input", test_num);
            reset_dut();

            @(negedge clk);
            in = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High frequency toggle", test_num);
            reset_dut();


            @(negedge clk); in = 1;
            @(negedge clk); in = 0;

            @(negedge clk); in = 1;
            @(negedge clk); in = 0;

            @(negedge clk); in = 1;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous reset mid-count", test_num);
            reset_dut();


            repeat(3) begin
                @(negedge clk); in = 0;
                @(negedge clk); in = 1;
                repeat(2) @(posedge clk);
            end


            @(negedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rising_edge_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, in, reset, count);
    end

endmodule
