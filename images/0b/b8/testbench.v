`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    reg request_free;
    reg request_malloc;
    reg [3:0] request_size;
    wire [3:0] alloc_address;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .address(address),
        .request_free(request_free),
        .request_malloc(request_malloc),
        .request_size(request_size),
        .alloc_address(alloc_address),
        .error(error)
    );
    task testcase001;

        begin
            $display("testcase001: Requesting 4 bytes...");
            request_malloc = 1;
            request_size = 4;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'h0, 1'b0);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Requesting 4 bytes...");
            request_malloc = 1;
            request_size = 4;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'h4, 1'b0);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Requesting 8 bytes...");
            request_malloc = 1;
            request_size = 8;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'h8, 1'b0);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Requesting 1 byte (Memory full)...");
            request_malloc = 1;
            request_size = 1;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'hF, 1'b1);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Freeing block at address 4...");
            request_malloc = 0;
            request_size = 0;
            request_free = 1;
            address = 4;

            #1;


            check_outputs(alloc_address, 1'b0);
            request_free = 0;
            #10;
        end
        endtask

    task testcase006;

        begin
            $display("testcase006: Requesting 2 bytes to fill hole at address 4...");
            request_malloc = 1;
            request_size = 2;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'h4, 1'b0);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase007;

        begin
            $display("testcase007: Requesting 3 bytes (only 2 left in current hole)...");
            request_malloc = 1;
            request_size = 3;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'hF, 1'b1);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase008;

        begin
            $display("testcase008: Freeing block at address 0...");
            request_malloc = 0;
            request_size = 0;
            request_free = 1;
            address = 0;
            #1;

            check_outputs(alloc_address, 1'b0);
            request_free = 0;
            #10;
        end
        endtask

    task testcase009;

        begin
            $display("testcase009: Requesting 4 bytes to fill hole at address 0...");
            request_malloc = 1;
            request_size = 4;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'h0, 1'b0);
            request_malloc = 0;
            #10;
        end
        endtask

    task testcase010;

        begin
            $display("testcase010: Requesting 17 bytes (oversized)...");
            request_malloc = 1;
            request_size = 15;
            request_free = 0;
            address = 0;

            #1;


            check_outputs(4'hF, 1'b1);
            request_malloc = 0;
            #10;
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_alloc_address;
        input expected_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alloc_address === (expected_alloc_address ^ alloc_address ^ expected_alloc_address) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: alloc_address=%h, error=%b",
                         alloc_address, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_address=%h, error=%b",
                         expected_alloc_address, expected_error);
                $display("  Got:      alloc_address=%h, error=%b",
                         alloc_address, error);
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

endmodule
