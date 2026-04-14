`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg alloc;
    reg clk;
    reg free;
    reg [2:0] req_size;
    reg rst;
    wire alloc_success;
    wire [4:0] memory_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .alloc(alloc),
        .clk(clk),
        .free(free),
        .req_size(req_size),
        .rst(rst),
        .alloc_success(alloc_success),
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
            req_size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Condition", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Allocation", test_num);
            reset_dut();

            alloc = 1;
            @(posedge clk);
            alloc = 0;
            @(posedge clk);



            #1;




            check_outputs(1'b1, 5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Allocations (3 blocks)", test_num);
            reset_dut();

            repeat(3) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 5'b00111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate Maximum Blocks", test_num);
            reset_dut();

            repeat(5) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Over-allocation Check", test_num);
            reset_dut();

            repeat(6) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b0, 5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Allocate and Free Index 0", test_num);
            reset_dut();


            alloc = 1;
            @(posedge clk);
            alloc = 0;
            @(posedge clk);


            free = 1;
            req_size = 3'd0;
            @(posedge clk);
            free = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Free Middle Block and Re-allocate", test_num);
            reset_dut();


            repeat(3) begin
                alloc = 1;
                @(posedge clk);
                alloc = 0;
                @(posedge clk);
            end


            free = 1;
            req_size = 3'd1;
            @(posedge clk);
            free = 0;
            @(posedge clk);


            alloc = 1;
            @(posedge clk);
            alloc = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 5'b00111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deallocate Empty Block", test_num);
            reset_dut();


            free = 1;
            req_size = 3'd4;
            @(posedge clk);
            free = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 5'b00000);
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
        input expected_alloc_success;
        input [4:0] expected_memory_status;
        begin
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success) &&
                expected_memory_status === (expected_memory_status ^ memory_status ^ expected_memory_status)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b, memory_status=%h",
                         alloc_success, memory_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b, memory_status=%h",
                         expected_alloc_success, expected_memory_status);
                $display("  Got:      alloc_success=%b, memory_status=%h",
                         alloc_success, memory_status);
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
        $dumpvars(0,alloc, clk, free, req_size, rst, alloc_success, memory_status);
    end

endmodule
