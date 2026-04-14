`timescale 1ns/1ps

module linked_list_traversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg insert;
    reg rst;
    wire [7:0] out_data;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linked_list_traversal dut (
        .clk(clk),
        .in_data(in_data),
        .insert(insert),
        .rst(rst),
        .out_data(out_data),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            insert = 0;
            in_data = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Insert 3 items", test_num);
            reset_dut();


            in_data = 8'hAA; insert = 1; @(posedge clk);
            in_data = 8'hBB; insert = 1; @(posedge clk);
            in_data = 8'hCC; insert = 1; @(posedge clk);
            insert = 0;



            while (!valid) @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
            @(posedge clk);
            #1;

            check_outputs(8'hBB, 1'b1);
            @(posedge clk);
            #1;

            check_outputs(8'hCC, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Maximum Capacity (5 items)", test_num);
            reset_dut();


            in_data = 8'h01; insert = 1; @(posedge clk);
            in_data = 8'h02; insert = 1; @(posedge clk);
            in_data = 8'h03; insert = 1; @(posedge clk);
            in_data = 8'h04; insert = 1; @(posedge clk);
            in_data = 8'h05; insert = 1; @(posedge clk);
            insert = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(8'h01, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'h02, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'h03, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'h04, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'h05, 1'b1); @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Overflow Check (Insert 6 items)", test_num);
            reset_dut();


            in_data = 8'hD1; insert = 1; @(posedge clk);
            in_data = 8'hD2; insert = 1; @(posedge clk);
            in_data = 8'hD3; insert = 1; @(posedge clk);
            in_data = 8'hD4; insert = 1; @(posedge clk);
            in_data = 8'hD5; insert = 1; @(posedge clk);
            in_data = 8'hD6; insert = 1; @(posedge clk);
            insert = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'hD1, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'hD2, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'hD3, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'hD4, 1'b1); @(posedge clk);
            #1;

            check_outputs(8'hD5, 1'b1); @(posedge clk);


            if (valid && out_data == 8'hD6) begin
                $display("FAIL: Overflow allowed 6th item");
                fail_count = fail_count + 1;
            end else begin
                $display("Overflow correctly handled.");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Single Item", test_num);
            reset_dut();

            in_data = 8'hFF; insert = 1; @(posedge clk);
            insert = 0;

            while (!valid) @(posedge clk);
            #1;

            check_outputs(8'hFF, 1'b1); @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linked_list_traversal Testbench");
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
        input [7:0] expected_out_data;
        input expected_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, valid=%b",
                         out_data, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, valid=%b",
                         expected_out_data, expected_valid);
                $display("  Got:      out_data=%h, valid=%b",
                         out_data, valid);
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
        $dumpvars(0,clk, in_data, insert, rst, out_data, valid);
    end

endmodule
