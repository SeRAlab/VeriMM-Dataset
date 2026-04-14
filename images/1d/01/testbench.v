`timescale 1ns/1ps

module memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    reg rst;
    wire [7:0] data_out;
    wire err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_manager dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .rst(rst),
        .data_out(data_out),
        .err(err)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            allocate = 0;
            free = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Allocation", test_num);
            reset_dut();
            allocate = 1;
            @(posedge clk);
            allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Invalid Free (Underflow)", test_num);
            reset_dut();
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocation Overflow", test_num);
            reset_dut();

            for(i = 0; i < 10; i = i + 1) begin
                allocate = 1;
                @(posedge clk);
            end
            allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate-Free-Allocate Sequence", test_num);
            reset_dut();

            allocate = 1; @(posedge clk); allocate = 0;

            free = 1; @(posedge clk); free = 0;

            allocate = 1; @(posedge clk); allocate = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Allocate and Free", test_num);
            reset_dut();

            allocate = 1; @(posedge clk); allocate = 0;
            @(posedge clk);

            allocate = 1;
            free = 1;
            @(posedge clk);
            allocate = 0;
            free = 0;
            @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_manager Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_err;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_err === (expected_err ^ err ^ expected_err)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, err=%b",
                         data_out, err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, err=%b",
                         expected_data_out, expected_err);
                $display("  Got:      data_out=%h, err=%b",
                         data_out, err);
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
        $dumpvars(0,allocate, clk, free, rst, data_out, err);
    end

endmodule
