`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] block_id;
    reg clk;
    reg [1:0] request;
    reg reset;
    wire [3:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .block_id(block_id),
        .clk(clk),
        .request(request),
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
            block_id = 0;
            request = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Allocate Block 0", test_num);
            reset_dut();
            @(posedge clk);
            block_id = 2'b00;
            request = 2'b01;
            @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Allocate Blocks 1 and 3", test_num);
            reset_dut();

            @(posedge clk);
            block_id = 2'b01;
            request = 2'b01;
            @(posedge clk);

            block_id = 2'b11;
            request = 2'b01;
            @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Allocate and Deallocate Block 2", test_num);
            reset_dut();

            @(posedge clk);
            block_id = 2'b10;
            request = 2'b01;
            @(posedge clk);

            block_id = 2'b10;
            request = 2'b10;
            @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Allocate all blocks (0,1,2,3)", test_num);
            reset_dut();
            @(posedge clk);
            block_id = 2'b00; request = 2'b01; @(posedge clk);
            block_id = 2'b01; request = 2'b01; @(posedge clk);
            block_id = 2'b10; request = 2'b01; @(posedge clk);
            block_id = 2'b11; request = 2'b01; @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify Request 00 (NOP)", test_num);
            reset_dut();

            @(posedge clk);
            block_id = 2'b00; request = 2'b01; @(posedge clk);

            block_id = 2'b01; request = 2'b00; @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Deallocate an already free block", test_num);
            reset_dut();
            @(posedge clk);
            block_id = 2'b11;
            request = 2'b10;
            @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Complex sequence", test_num);
            reset_dut();

            @(posedge clk);
            block_id = 2'b00; request = 2'b01; @(posedge clk);
            block_id = 2'b01; request = 2'b01; @(posedge clk);
            block_id = 2'b10; request = 2'b01; @(posedge clk);

            block_id = 2'b01; request = 2'b10; @(posedge clk);

            block_id = 2'b11; request = 2'b01; @(posedge clk);
            request = 2'b00;
            #1;

            check_outputs(4'b1101);
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
        $dumpvars(0,block_id, clk, request, reset, status);
    end

endmodule
