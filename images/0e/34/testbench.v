`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] start_addr;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .clk(clk),
        .rst(rst),
        .start_addr(start_addr),
        .data_out(data_out),
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
            start_addr = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Single Node List", test_num);
            reset_dut();


            dut.memory[8'h10] = {8'hAA, 8'h00};

            start_addr = 8'h10;


            @(posedge clk);
            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Multi-Node List", test_num);
            reset_dut();

            dut.memory[8'h20] = {8'h11, 8'h25};
            dut.memory[8'h25] = {8'h22, 8'h30};
            dut.memory[8'h30] = {8'h33, 8'h00};

            start_addr = 8'h20;

            @(posedge clk);
            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Empty List (Null Start)", test_num);
            reset_dut();

            start_addr = 8'h00;

            @(posedge clk);
            repeat(2) @(posedge clk);


            #1;



            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: High Address and Wrap/Jump", test_num);
            reset_dut();

            dut.memory[8'hFE] = {8'h99, 8'h01};
            dut.memory[8'h01] = {8'h88, 8'h00};

            start_addr = 8'hFE;

            @(posedge clk);
            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'h88, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Long List Traversal (5 nodes)", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                dut.memory[8'h40 + i] = {8'hA0 + i, 8'h40 + i + 1};
            end
            dut.memory[8'h44] = {8'hA4, 8'h00};

            start_addr = 8'h40;

            @(posedge clk);
            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'hA4, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
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
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, rst, start_addr, data_out, done);
    end

endmodule
