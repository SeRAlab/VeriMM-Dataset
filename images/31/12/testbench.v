`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg clk;
    reg free;
    reg [3:0] mem_id;
    reg reset;
    wire [3:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc(alloc),
        .clk(clk),
        .free(free),
        .mem_id(mem_id),
        .reset(reset),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            alloc = 0;
            free = 0;
            mem_id = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            mem_id = 4'd5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking initial status of ID 5", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            mem_id = 4'd3;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking status of ID 3 after allocation", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            mem_id = 4'd7;
            alloc = 1;
            @(posedge clk);
            #1 alloc = 0;
            @(posedge clk);

            free = 1;
            @(posedge clk);
            #1 free = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking status of ID 7 after allocate and free", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            mem_id = 4'd1; alloc = 1; @(posedge clk); #1;

            mem_id = 4'd2; alloc = 1; @(posedge clk); #1;

            mem_id = 4'd3; alloc = 1; @(posedge clk); #1 alloc = 0;
            @(posedge clk);
            mem_id = 4'd2;
            #1;
            $display("Testcase %0d: Checking status of ID 2 after multiple allocations", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            mem_id = 4'd10; alloc = 1; @(posedge clk); #1;
            mem_id = 4'd11; alloc = 1; @(posedge clk); #1;
            mem_id = 4'd12; alloc = 1; @(posedge clk); #1 alloc = 0;
            @(posedge clk);

            mem_id = 4'd11; free = 1; @(posedge clk); #1 free = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking status of ID 11 after freeing it among others", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            mem_id = 4'd1; alloc = 1; @(posedge clk); #1;
            mem_id = 4'd2; alloc = 1; @(posedge clk); #1 alloc = 0;
            @(posedge clk);

            mem_id = 4'd1; free = 1; @(posedge clk); #1 free = 0;
            @(posedge clk);

            mem_id = 4'd2;
            #1;
            $display("Testcase %0d: Checking status of ID 2 after ID 1 was freed", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            mem_id = 4'd4; alloc = 1; @(posedge clk); #1 alloc = 0; @(posedge clk);
            mem_id = 4'd4; free = 1; @(posedge clk); #1 free = 0; @(posedge clk);
            mem_id = 4'd4; alloc = 1; @(posedge clk); #1 alloc = 0; @(posedge clk);
            #1;
            $display("Testcase %0d: Checking status of ID 4 after re-allocation", test_num);
            #1;

            check_outputs(4'd1);
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
        input [3:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,alloc, clk, free, mem_id, reset, status);
    end

endmodule
