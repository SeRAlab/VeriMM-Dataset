`timescale 1ns/1ps

module rrt_node_tb;

    // Testbench signals (sequential circuit)
    reg add_node;
    reg clk;
    reg rst_n;
    reg [7:0] x_in;
    reg [7:0] y_in;
    wire success;
    wire [7:0] x_out;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node dut (
        .add_node(add_node),
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_in(y_in),
        .success(success),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            add_node = 0;
            x_in = 0;
            y_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Add Single Node", test_num);
            reset_dut();

            @(posedge clk);
            x_in = 8'h0A;
            y_in = 8'h14;
            add_node = 1;

            @(posedge clk);
            add_node = 0;


            #1;



            check_outputs(1'b1, 8'h0A, 8'h14);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Fill to Capacity (5 Nodes)", test_num);
            reset_dut();

            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                x_in = i;
                y_in = i + 10;
                add_node = 1;
                @(posedge clk);
                add_node = 0;
            end


            #1;



            check_outputs(1'b1, 8'h05, 8'h0F);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Buffer Overflow Check", test_num);
            reset_dut();


            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                x_in = i;
                y_in = i;
                add_node = 1;
                @(posedge clk);
            end


            x_in = 8'hFF;
            y_in = 8'hEE;
            add_node = 1;
            @(posedge clk);
            add_node = 0;




            #1;





            check_outputs(1'b0, x_out, y_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Boundary Values", test_num);
            reset_dut();

            @(posedge clk);
            x_in = 8'h00;
            y_in = 8'hFF;
            add_node = 1;

            @(posedge clk);
            add_node = 0;

            #1;


            check_outputs(1'b1, 8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset Mid-Operation", test_num);
            reset_dut();


            repeat(3) begin
                @(posedge clk);
                add_node = 1;
                x_in = x_in + 1;
                @(posedge clk);
                add_node = 0;
            end


            reset_dut();


            @(posedge clk);
            x_in = 8'hAA;
            y_in = 8'hBB;
            add_node = 1;
            @(posedge clk);
            add_node = 0;

            #1;


            check_outputs(1'b1, 8'hAA, 8'hBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_node Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_success;
        input [7:0] expected_x_out;
        input [7:0] expected_y_out;
        begin
            if (expected_success === (expected_success ^ success ^ expected_success) &&
                expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: success=%b, x_out=%h, y_out=%h",
                         success, x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: success=%b, x_out=%h, y_out=%h",
                         expected_success, expected_x_out, expected_y_out);
                $display("  Got:      success=%b, x_out=%h, y_out=%h",
                         success, x_out, y_out);
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
        $dumpvars(0,add_node, clk, rst_n, x_in, y_in, success, x_out, y_out);
    end

endmodule
