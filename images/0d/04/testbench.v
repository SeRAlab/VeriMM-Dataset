`timescale 1ns/1ps

module dfs_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg valid;
    reg [7:0] value;
    wire done;
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dfs_tree dut (
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .value(value),
        .done(done),
        .output_value(output_value)
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
            value = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Single Node", test_num);
            reset_dut();

            value = 8'h05; valid = 1;
            @(posedge clk);
            valid = 0;


            wait(done);
            #1;

            check_outputs(1'b1, 8'h05);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: 3-Node Balanced Tree", test_num);
            reset_dut();


            value = 8'd10; valid = 1; @(posedge clk);
            value = 8'd20; valid = 1; @(posedge clk);
            value = 8'd30; valid = 1; @(posedge clk);
            valid = 0;

            wait(done);

            #1;


            check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Left-Skewed Tree", test_num);
            reset_dut();

            value = 8'd100; valid = 1; @(posedge clk);
            value = 8'd80;  valid = 1; @(posedge clk);
            value = 8'd00;  valid = 1; @(posedge clk);
            value = 8'd60;  valid = 1; @(posedge clk);
            valid = 0;

            wait(done);
            #1;

            check_outputs(1'b1, 8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: 5-Node Complex Tree", test_num);
            reset_dut();

            value = 8'd01; valid = 1; @(posedge clk);
            value = 8'd02; valid = 1; @(posedge clk);
            value = 8'd03; valid = 1; @(posedge clk);
            value = 8'd04; valid = 1; @(posedge clk);
            value = 8'd05; valid = 1; @(posedge clk);
            valid = 0;

            wait(done);

            #1;


            check_outputs(1'b1, 8'd03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dfs_tree Testbench");
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
        input expected_done;
        input [7:0] expected_output_value;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_value=%h",
                         done, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_value=%h",
                         expected_done, expected_output_value);
                $display("  Got:      done=%b, output_value=%h",
                         done, output_value);
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
        $dumpvars(0,clk, rst, valid, value, done, output_value);
    end

endmodule
