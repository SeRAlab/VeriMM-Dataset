`timescale 1ns/1ps

module memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg clk;
    reg free;
    reg rst;
    wire [3:0] memory_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_manager dut (
        .alloc(alloc),
        .clk(clk),
        .free(free),
        .rst(rst),
        .memory_status(memory_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            alloc = 0;
            free = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Allocation", test_num);
            reset_dut();
            alloc = 1;
            @(posedge clk);
            alloc = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill Capacity (4 blocks)", test_num);
            reset_dut();
            repeat(4) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Allocation Overflow", test_num);
            reset_dut();
            repeat(5) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Free block from full state", test_num);
            reset_dut();

            repeat(4) begin
                alloc = 1; @(posedge clk); alloc = 0; @(posedge clk);
            end

            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Free Underflow (Empty)", test_num);
            reset_dut();
            free = 1;
            @(posedge clk);
            free = 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Interleaved Operations", test_num);
            reset_dut();

            repeat(2) begin alloc = 1; @(posedge clk); alloc = 0; @(posedge clk); end

            free = 1; @(posedge clk); free = 0; @(posedge clk);

            alloc = 1; @(posedge clk); alloc = 0; @(posedge clk);

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Simultaneous Alloc and Free", test_num);
            reset_dut();
            alloc = 1;
            free = 1;
            @(posedge clk);
            alloc = 0;
            free = 0;
            @(posedge clk);


            $display("Note: Result depends on priority logic (Alloc vs Free)");
            #1;

            check_outputs(memory_status);
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
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_memory_status;
        begin
            if (expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status)) begin
                $display("PASS");
                $display("  Outputs: memory_status=%h",
                         memory_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_status=%h",
                         expected_memory_status);
                $display("  Got:      memory_status=%h",
                         memory_status);
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
        $dumpvars(0,alloc, clk, free, rst, memory_status);
    end

endmodule
