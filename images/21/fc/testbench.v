`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] request_size;
    wire [4:0] address;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .request_size(request_size),
        .address(address),
        .success(success)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 10 bytes (Valid)", test_num);
            request_size = 8'd10;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 32 bytes (Boundary Max)", test_num);
            request_size = 8'd32;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 33 bytes (Overflow)", test_num);
            request_size = 8'd33;

            #1;


            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 1 byte (Boundary Min)", test_num);
            request_size = 8'd1;
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 255 bytes (Large Overflow)", test_num);
            request_size = 8'd255;
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Requesting 0 bytes (Edge Case)", test_num);
            request_size = 8'd0;
            #1;

            check_outputs(5'd0, 1'b1);
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
        input [4:0] expected_address;
        input expected_success;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: address=%h, success=%b",
                         address, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, success=%b",
                         expected_address, expected_success);
                $display("  Got:      address=%h, success=%b",
                         address, success);
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
