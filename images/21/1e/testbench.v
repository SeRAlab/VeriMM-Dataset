`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg allocate;
    reg clk;
    reg free;
    reg [2:0] index;
    reg reset;
    wire [2:0] allocated_index;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .allocate(allocate),
        .clk(clk),
        .free(free),
        .index(index),
        .reset(reset),
        .allocated_index(allocated_index),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            allocate = 0;
            free = 0;
            index = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                allocate = 1;
                @(posedge clk);
                #1 allocate = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(3'd7, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                allocate = 1;
                @(posedge clk);
                #1 allocate = 0;
                @(posedge clk);
            end

            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(allocated_index, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            repeat(3) begin
                allocate = 1;
                @(posedge clk);
                #1 allocate = 0;
                @(posedge clk);
            end

            index = 3'd1;
            free = 1;
            @(posedge clk);
            #1 free = 0;
            @(posedge clk);

            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(3'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(4) begin
                allocate = 1; @(posedge clk); #1 allocate = 0; @(posedge clk);
            end

            index = 3'd0; free = 1; @(posedge clk); #1 free = 0; @(posedge clk);

            index = 3'd2; free = 1; @(posedge clk); #1 free = 0; @(posedge clk);


            allocate = 1; @(posedge clk); #1 allocate = 0;
            #1;

            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(5) begin
                allocate = 1; @(posedge clk); #1 allocate = 0; @(posedge clk);
            end
            reset_dut();
            allocate = 1;
            @(posedge clk);
            #1 allocate = 0;
            #1;

            check_outputs(3'd0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_allocator Testbench");
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
        input [2:0] expected_allocated_index;
        input expected_error;
        begin
            if (expected_allocated_index === (expected_allocated_index ^ allocated_index ^ expected_allocated_index) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: allocated_index=%h, error=%b",
                         allocated_index, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_index=%h, error=%b",
                         expected_allocated_index, expected_error);
                $display("  Got:      allocated_index=%h, error=%b",
                         allocated_index, error);
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
        $dumpvars(0,allocate, clk, free, index, reset, allocated_index, error);
    end

endmodule
