`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (combinational circuit)
    reg request;
    reg [3:0] request_size;
    wire error;
    wire [3:0] start_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .request(request),
        .request_size(request_size),
        .error(error),
        .start_address(start_address)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Requesting 4 units...", test_num);
            request = 1'b1;
            request_size = 4'd4;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Requesting 15 units...", test_num);
            request = 1'b1;
            request_size = 4'd15;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: No request signal active...", test_num);
            request = 1'b0;
            request_size = 4'd8;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Requesting 0 (interpreted as 16) units...", test_num);
            request = 1'b1;
            request_size = 4'd0;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Requesting 8 units...", test_num);
            request = 1'b1;
            request_size = 4'd8;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Requesting 1 unit...", test_num);
            request = 1'b1;
            request_size = 4'd1;

            #1;


            check_outputs(1'b0, 4'h0);
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
        input expected_error;
        input [3:0] expected_start_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_start_address === (expected_start_address ^ start_address ^ expected_start_address)) begin
                $display("PASS");
                $display("  Outputs: error=%b, start_address=%h",
                         error, start_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, start_address=%h",
                         expected_error, expected_start_address);
                $display("  Got:      error=%b, start_address=%h",
                         error, start_address);
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
