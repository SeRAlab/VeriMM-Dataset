`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] block_id;
    reg clk;
    reg free_req;
    reg malloc_req;
    reg [7:0] request_size;
    reg reset;
    wire [7:0] allocated_id;
    wire [15:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .block_id(block_id),
        .clk(clk),
        .free_req(free_req),
        .malloc_req(malloc_req),
        .request_size(request_size),
        .reset(reset),
        .allocated_id(allocated_id),
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
            malloc_req = 0;
            free_req = 0;
            request_size = 0;
            block_id = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Malloc 16 bytes", test_num);
            reset_dut();

            malloc_req = 1;
            request_size = 8'd16;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);



            #1;




            check_outputs(8'h00, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Malloc size exceeding capacity", test_num);
            reset_dut();

            malloc_req = 1;
            request_size = 8'd255;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 16'h0002);
        end
        endtask

    task testcase003;

        reg [7:0] captured_id;
        begin
            test_num = 3;
            $display("Testcase %0d: Malloc then Free", test_num);
            reset_dut();


            malloc_req = 1;
            request_size = 8'd8;
            @(posedge clk);
            captured_id = allocated_id;
            malloc_req = 0;
            @(posedge clk);


            free_req = 1;
            block_id = captured_id;
            @(posedge clk);
            free_req = 0;
            @(posedge clk);


            #1;



            check_outputs(captured_id, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential Allocations", test_num);
            reset_dut();


            malloc_req = 1;
            request_size = 8'd4;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);


            malloc_req = 1;
            request_size = 8'd4;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h04, 16'h0001);
        end
        endtask

    task testcase005;

        reg [7:0] first_id;
        begin
            test_num = 5;
            $display("Testcase %0d: Memory Reuse", test_num);
            reset_dut();


            malloc_req = 1;
            request_size = 8'd10;
            @(posedge clk);
            first_id = allocated_id;
            malloc_req = 0;
            @(posedge clk);


            free_req = 1;
            block_id = first_id;
            @(posedge clk);
            free_req = 0;
            @(posedge clk);


            malloc_req = 1;
            request_size = 8'd10;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);


            #1;



            check_outputs(first_id, 16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Malloc size 0", test_num);
            reset_dut();

            malloc_req = 1;
            request_size = 8'd0;
            @(posedge clk);
            malloc_req = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 16'h0002);
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
        input [7:0] expected_allocated_id;
        input [15:0] expected_status;
        begin
            if (expected_allocated_id === (expected_allocated_id ^ allocated_id ^ expected_allocated_id) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: allocated_id=%h, status=%h",
                         allocated_id, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocated_id=%h, status=%h",
                         expected_allocated_id, expected_status);
                $display("  Got:      allocated_id=%h, status=%h",
                         allocated_id, status);
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
        $dumpvars(0,block_id, clk, free_req, malloc_req, request_size, reset, allocated_id, status);
    end

endmodule
